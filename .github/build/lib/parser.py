"""
AsciiDoc table parser for ILCD+EPD documentation.

Parses the custom ##...## table format used in AsciiDoc files.
"""

import re
import pandas as pd


def parse_asciidoc_table(filename: str, table_pattern: str = r'\.EPD Data Structure') -> pd.DataFrame:
    """
    Parse an AsciiDoc table with ##...## cell delimiters.

    Args:
        filename: Path to the AsciiDoc file
        table_pattern: Regex pattern to match the table title (default: '.EPD Data Structure')

    Returns:
        DataFrame with parsed table data
    """
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # Build regex to find the table
    pattern = table_pattern + r'\n.*?\|===(.*?)(\|===)'
    table_match = re.search(pattern, content, re.DOTALL)
    if not table_match:
        raise ValueError(f"Could not find table matching '{table_pattern}' in {filename}")

    table_content = table_match.group(1).strip()

    # Parse headers
    header_match = re.search(r'(\| \[role="title"\]##.*?##\n)+', table_content)
    if not header_match:
        raise ValueError("Could not parse the table header.")

    header_str = header_match.group(0)
    headers = [h.strip() for h in re.findall(r'##(.*?)##', header_str)]

    # Parse body cells
    body_str = table_content[len(header_str):].strip()
    cells = [c.strip() for c in re.findall(r'##(.*?)##', body_str, re.DOTALL)]

    num_columns = len(headers)

    # Pad incomplete rows
    if len(cells) % num_columns != 0:
        padding = num_columns - (len(cells) % num_columns)
        cells.extend([''] * padding)

    rows = [cells[i:i + num_columns] for i in range(0, len(cells), num_columns)]

    df = pd.DataFrame(rows, columns=headers)

    # Clean up AsciiDoc artifacts
    df.replace('{nbsp}', '', regex=True, inplace=True)

    # Strip whitespace from all string columns after {nbsp} removal
    for col in df.columns:
        if df[col].dtype == 'object':
            df[col] = df[col].str.strip()

    # Convert Indent column to numeric
    if 'Indent' in df.columns:
        df['Indent'] = pd.to_numeric(df['Indent'], errors='coerce').fillna(0).astype(int)
    else:
        df['Indent'] = 0

    return df


def extract_title_from_adoc(filename: str) -> str:
    """
    Extract the document title from an AsciiDoc file.

    Args:
        filename: Path to the AsciiDoc file

    Returns:
        Document title string
    """
    import os
    with open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            if line.startswith('= '):
                return line[2:].strip().replace(' Documentation', '')
    return os.path.basename(filename).replace('.adoc', '')


def sanitize_filename(path: str) -> str:
    """
    Convert a path to a safe filename.

    Args:
        path: Original path string

    Returns:
        Sanitized filename safe for filesystem use
    """
    return re.sub(r'[^a-zA-Z0-9._-]', '_', str(path))
