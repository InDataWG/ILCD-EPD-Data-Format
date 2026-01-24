#!/usr/bin/env python3
"""
ILCD+EPD CSV to HTML Conversion Script

Converts CSV files to interactive HTML pages for branch previews.
Used for identifier tables in preview deployments.

Usage:
    python build_csv_pages.py <output_dir>
"""

import os
import sys
import glob
import logging
import pandas as pd
from jinja2 import Environment, FileSystemLoader

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

# --- Directory Configuration ---
BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(BUILD_DIR))
DOC_DIR = os.path.join(BASE_DIR, 'doc')
TEMPLATES_DIR = os.path.join(BUILD_DIR, 'templates')


def setup_jinja_env():
    """Set up Jinja2 environment."""
    return Environment(
        loader=FileSystemLoader(TEMPLATES_DIR),
        autoescape=True
    )


def generate_csv_html_pages(env, csv_dir, output_dir):
    """Convert CSV files to HTML pages."""
    logger.info("Converting CSV files to HTML...")

    csv_pattern = os.path.join(csv_dir, '*.csv')
    csv_files = glob.glob(csv_pattern)

    if not csv_files:
        logger.warning(f"No CSV files found in {csv_dir}")
        return

    os.makedirs(output_dir, exist_ok=True)
    template = env.get_template('csv_table.html.j2')

    for csv_path in sorted(csv_files):
        filename = os.path.basename(csv_path)
        display_name = filename.replace('.csv', '').replace('_', ' ')

        try:
            df = pd.read_csv(csv_path)
            html = template.render(
                display_name=display_name,
                columns=df.columns.tolist(),
                rows=df.to_dict('records')
            )

            output_path = os.path.join(output_dir, filename.replace('.csv', '.html'))
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(html)
            logger.info(f"  Converted: {filename}")

        except Exception as e:
            logger.error(f"  Error converting {filename}: {e}")


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        logger.error("Usage: python build_csv_pages.py <output_dir>")
        logger.error("  output_dir: Directory where HTML files will be written")
        return 1

    output_dir = sys.argv[1]

    try:
        # Set up Jinja2
        env = setup_jinja_env()

        # Generate CSV HTML pages
        csv_src = os.path.join(DOC_DIR, 'identifiers')
        generate_csv_html_pages(env, csv_src, output_dir)

        logger.info("CSV to HTML conversion completed successfully!")
        return 0

    except FileNotFoundError as e:
        logger.error(f"File not found: {e}")
        return 1
    except Exception as e:
        logger.error(f"Fatal error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
