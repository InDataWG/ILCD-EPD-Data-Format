#!/usr/bin/env python3
"""
ILCD+EPD Main Documentation Build Script

Generates the main HTML documentation from AsciiDoc sources:
- Main ILCD+EPD HTML table (index.html)
- Individual attribute detail pages
- CSV export
- Static assets (CSS/JS)

Usage:
    python build_docs.py
"""

import os
import re
import sys
import shutil
import logging
from jinja2 import Environment, FileSystemLoader

from lib.parser import parse_asciidoc_table, sanitize_filename

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

# --- Directory Configuration ---
BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(BUILD_DIR))
DOC_DIR = os.path.join(BASE_DIR, 'doc')
TEMPLATES_DIR = os.path.join(BUILD_DIR, 'templates')

# --- Column Configuration ---
MAIN_COLUMNS = [
    'order', 'ID previous', 'ID new', 'Format version ID (when introduced)',
    'Field Name (de)', 'Field Name (en)', 'Element/Attribute Name',
    'Technically Required', 'Occ.', 'Datatype',
    'Original ILCD Format Definition (en)', 'Definition (de)',
    'InData Definition (en)', 'Further explanations (EN)',
    'InData compliance CP-2020', 'Deviation to ILCD format definition',
    'Extension of ILCD format', 'InData Compliance Construction Products CPEN2020',
    'eDoc ID', 'Example of expected information in the field',
    'EN15804+A2 mapping (chapter number)', 'EN15804+A2 required information',
    'ECO Platform conformity', 'ISO 22057 mapping (GUID)',
    'ISO 22057 required information', 'ISO 21930 mapping',
    'ISO 21930 required information',
]


def setup_jinja_env():
    """Set up Jinja2 environment with custom filters."""
    env = Environment(
        loader=FileSystemLoader(TEMPLATES_DIR),
        autoescape=True
    )

    def regex_match(value, pattern):
        """Custom filter to match regex and return groups."""
        match = re.match(pattern, str(value))
        if match:
            return match.groups()
        return None

    env.filters['regex_match'] = regex_match
    return env


def detect_enum_groups(df):
    """
    Detect groups of rows that represent enum values for the same field.

    Returns a dict mapping start_idx to {end_idx, values}.
    """
    enum_groups = {}
    i = 0
    while i < len(df):
        if i + 1 < len(df):
            next_datatype = str(df.iloc[i + 1].get('Datatype', '')).strip()
            if re.match(r'^[A-Z] - ', next_datatype):
                start_idx = i
                j = i + 1
                enum_values = []
                while j < len(df):
                    curr_datatype = str(df.iloc[j].get('Datatype', '')).strip()
                    if re.match(r'^[A-Z] - ', curr_datatype):
                        enum_values.append(curr_datatype)
                        j += 1
                    else:
                        break
                if enum_values:
                    enum_groups[start_idx] = {
                        'end_idx': j - 1,
                        'values': enum_values
                    }
                    i = j
                    continue
        i += 1
    return enum_groups


def generate_main_report(env, df, output_path):
    """Generate the main ILCD+EPD HTML report."""
    logger.info("Generating main HTML report...")

    template = env.get_template('index.html.j2')
    enum_groups = detect_enum_groups(df)

    rows = df.to_dict('records')
    html = template.render(
        columns=MAIN_COLUMNS,
        rows=rows,
        enum_groups=enum_groups
    )

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)
    logger.info(f"  Generated: {output_path}")


def generate_attribute_pages(env, df, output_dir):
    """Generate individual attribute detail pages."""
    logger.info("Generating attribute pages...")

    os.makedirs(output_dir, exist_ok=True)
    template = env.get_template('attribute_page.html.j2')
    pages = []

    for idx, row in df.iterrows():
        path = str(row.get('Path', f'row_{idx}'))
        safe_filename = sanitize_filename(path)
        element_name = str(row.get('Element/Attribute Name', '')).replace('|&nbsp;&nbsp;', '').strip()

        html = template.render(
            element_name=element_name,
            path=path,
            fields=row.to_dict()
        )

        filepath = os.path.join(output_dir, f"{safe_filename}.html")
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(html)

        pages.append({
            'path': path,
            'filename': f"{safe_filename}.html"
        })

    # Generate index page
    index_template = env.get_template('attribute_index.html.j2')
    index_html = index_template.render(pages=pages)
    index_path = os.path.join(output_dir, 'index.html')
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(index_html)

    logger.info(f"  Generated {len(pages)} attribute pages in {output_dir}")


def generate_csv(df, output_path):
    """Generate CSV file from DataFrame."""
    logger.info("Generating CSV...")
    df.to_csv(output_path, index=False, encoding='utf-8-sig')
    logger.info(f"  Generated: {output_path}")


def copy_static_assets(output_dir):
    """Copy CSS and JS files to output directory."""
    logger.info("Copying static assets...")

    css_src = os.path.join(BUILD_DIR, 'css')
    js_src = os.path.join(BUILD_DIR, 'js')
    css_dst = os.path.join(output_dir, 'css')
    js_dst = os.path.join(output_dir, 'js')

    if os.path.exists(css_src):
        shutil.copytree(css_src, css_dst, dirs_exist_ok=True)
        logger.info(f"  Copied CSS to {css_dst}")

    if os.path.exists(js_src):
        shutil.copytree(js_src, js_dst, dirs_exist_ok=True)
        logger.info(f"  Copied JS to {js_dst}")


def main():
    """Main entry point."""
    try:
        # Ensure output directories exist
        os.makedirs(DOC_DIR, exist_ok=True)
        os.makedirs(os.path.join(DOC_DIR, 'css'), exist_ok=True)
        os.makedirs(os.path.join(DOC_DIR, 'js'), exist_ok=True)

        # Set up Jinja2
        env = setup_jinja_env()

        # Parse main AsciiDoc source
        adoc_source = os.path.join(DOC_DIR, 'asciidoc', 'ilcd-epd-v1.3.adoc')
        logger.info(f"Parsing {adoc_source}...")
        df_main = parse_asciidoc_table(adoc_source)

        # Generate all outputs
        generate_main_report(env, df_main, os.path.join(DOC_DIR, 'index.html'))
        generate_attribute_pages(env, df_main, os.path.join(DOC_DIR, 'attribute_pages'))
        generate_csv(df_main, os.path.join(DOC_DIR, 'ilcd-epd-v1.3.csv'))

        # Copy static assets to main doc folder
        copy_static_assets(DOC_DIR)

        logger.info("Main documentation build completed successfully!")
        return 0

    except FileNotFoundError as e:
        logger.error(f"File not found: {e}")
        return 1
    except ValueError as e:
        logger.error(f"Value error: {e}")
        return 1
    except Exception as e:
        logger.error(f"Fatal error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
