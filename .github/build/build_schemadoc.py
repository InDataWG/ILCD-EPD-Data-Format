#!/usr/bin/env python3
"""
ILCD+EPD Schema Documentation Build Script

Generates HTML documentation for schema files:
- Schemadoc HTML reports for each schema
- Attribute pages with breadcrumb navigation
- Copies schema source files to data folder

Usage:
    python build_schemadoc.py
"""

import os
import re
import sys
import shutil
import logging
from jinja2 import Environment, FileSystemLoader

from lib.parser import parse_asciidoc_table, extract_title_from_adoc, sanitize_filename

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

# --- Directory Configuration ---
BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(BUILD_DIR))
DOC_DIR = os.path.join(BASE_DIR, 'doc')
TEMPLATES_DIR = os.path.join(BUILD_DIR, 'templates')

# --- Column Configuration ---
SCHEMADOC_COLUMNS = [
    'Field Name', 'Element/Attribute Name', 'Requ.', 'Occ.',
    'Datatype', 'Definition', 'eDoc ID',
]

SCHEMADOC_DISPLAY_COLUMNS = SCHEMADOC_COLUMNS + ['Path']


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


def generate_schemadoc_reports(env, data_dir, output_dir):
    """Generate schemadoc HTML reports and attribute pages."""
    logger.info("Generating schemadoc documentation...")

    if not os.path.exists(data_dir):
        logger.warning(f"Schemadoc source directory not found: {data_dir}")
        return

    os.makedirs(output_dir, exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'css'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'js'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'attribute_pages'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'data'), exist_ok=True)

    adoc_files = [f for f in os.listdir(data_dir) if f.endswith('.adoc')]
    logger.info(f"  Found {len(adoc_files)} schemadoc files")

    report_template = env.get_template('schemadoc.html.j2')
    attr_template = env.get_template('schemadoc_attribute.html.j2')

    for adoc_file in sorted(adoc_files):
        adoc_path = os.path.join(data_dir, adoc_file)
        base_name = os.path.splitext(adoc_file)[0]

        try:
            df = parse_asciidoc_table(adoc_path, r'\.[^\n]+ Data Structure')
            title = extract_title_from_adoc(adoc_path)
            rows = df.to_dict('records')

            # Generate main report
            html = report_template.render(
                title=title,
                columns=SCHEMADOC_COLUMNS,
                rows=rows
            )
            output_path = os.path.join(output_dir, f"{base_name}.html")
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(html)
            logger.info(f"    Generated: {output_path}")

            # Generate attribute pages
            attr_dir = os.path.join(output_dir, 'attribute_pages')
            for idx, row in df.iterrows():
                path = row.get('Path', '')
                if not path:
                    continue

                safe_path = sanitize_filename(path)
                element_name = str(row.get('Element/Attribute Name', '')).strip()
                field_name = str(row.get('Field Name', ''))

                # Build breadcrumb
                path_parts = path.split('/') if path else []
                breadcrumb = ''
                if path_parts:
                    crumbs = []
                    accumulated = ""
                    for part in path_parts[:-1]:
                        accumulated = f"{accumulated}/{part}" if accumulated else part
                        safe_acc = sanitize_filename(accumulated)
                        crumbs.append(f'<a href="{safe_acc}.html">{part}</a>')
                    if crumbs:
                        breadcrumb = " / ".join(crumbs) + f" / <strong>{path_parts[-1]}</strong>"
                    else:
                        breadcrumb = f"<strong>{path_parts[-1] if path_parts else element_name}</strong>"

                # Find children
                children = []
                if path:
                    for _, child_row in df.iterrows():
                        child_path = child_row.get('Path', '')
                        if (child_path.startswith(path + '/') and
                                child_path.count('/') == path.count('/') + 1):
                            children.append({
                                'safe_path': sanitize_filename(child_path),
                                'element_name': str(child_row.get('Element/Attribute Name', '')).strip(),
                                'field_name': str(child_row.get('Field Name', ''))
                            })

                attr_html = attr_template.render(
                    element_name=element_name,
                    doc_title=title,
                    back_link_file=base_name,
                    breadcrumb=breadcrumb,
                    field_name=field_name,
                    row=row.to_dict(),
                    display_columns=SCHEMADOC_DISPLAY_COLUMNS,
                    children=children
                )

                attr_path = os.path.join(attr_dir, f"{safe_path}.html")
                with open(attr_path, 'w', encoding='utf-8') as f:
                    f.write(attr_html)

            # Copy source file to data folder
            shutil.copy(adoc_path, os.path.join(output_dir, 'data', adoc_file))

        except Exception as e:
            logger.error(f"    Error processing {adoc_file}: {e}")

    # Copy static assets
    src_css = os.path.join(BUILD_DIR, 'css', 'style.css')
    src_js = os.path.join(BUILD_DIR, 'js', 'schemadoc_script.js')
    if os.path.exists(src_css):
        shutil.copy(src_css, os.path.join(output_dir, 'css', 'style.css'))
    if os.path.exists(src_js):
        shutil.copy(src_js, os.path.join(output_dir, 'js', 'schemadoc_script.js'))


def main():
    """Main entry point."""
    try:
        # Set up Jinja2
        env = setup_jinja_env()

        # Generate schemadoc
        schemadoc_src = os.path.join(DOC_DIR, 'asciidoc', 'schemadoc_adoc')
        schemadoc_out = os.path.join(DOC_DIR, 'schemadoc')
        generate_schemadoc_reports(env, schemadoc_src, schemadoc_out)

        logger.info("Schemadoc build completed successfully!")
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
