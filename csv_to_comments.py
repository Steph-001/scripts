#!/usr/bin/env python3
"""
CSV to Student Comments Generator

Convert a CSV file of student names into a formatted comments template.
Supports multiple output formats: markdown, plain text, and CSV.
"""

import csv
import sys
import os
from pathlib import Path


def show_help():
    """Display detailed help information."""
    help_text = """
CSV to Student Comments Generator
==================================

USAGE:
    python3 csv_to_comments.py INPUT_FILE [FORMAT]

ARGUMENTS:
    INPUT_FILE    Path to the CSV file containing student names
                  Supports two formats:
                  - Clean CSV: First Name, Surname (comma-separated)
                  - Grade sheet: SURNAME First-name (semicolon-separated)
    
    FORMAT        Output format (optional, default: md)
                  Options:
                  - md     Markdown format (.md)
                  - txt    Plain text format (.txt)
                  - csv    CSV format (.csv)
                  - all    Generate all three formats

EXAMPLES:
    # Generate markdown file (default)
    python3 csv_to_comments.py students.csv
    
    # Generate plain text file
    python3 csv_to_comments.py students.csv txt
    
    # Generate all formats
    python3 csv_to_comments.py students.csv all

INPUT FILE FORMATS:
    
    1. Clean CSV (comma-separated):
       First Name,Surname
       John,Smith
       Marie,Dupont
    
    2. Grade Sheet (semicolon-separated):
       SMITH John;12;15;...
       DUPONT Marie;14;13;...

OUTPUT:
    Files are created in the current directory with names like:
    - comments_students.md
    - comments_students.txt
    - comments_students.csv

OPTIONS:
    -h, --help    Show this help message

NOTES:
    - Students are automatically sorted by surname
    - Grade sheets skip header rows and summary rows
    - UTF-8 encoding is used for all files
"""
    print(help_text)


def extract_students(csv_file):
    """Extract student names from CSV file.
    
    Handles two formats:
    1. Clean CSV: First Name, Surname (comma-separated)
    2. Grade sheet: SURNAME First-name (semicolon-separated)
    
    Returns:
        list: List of (first_name, surname) tuples sorted by surname
    """
    students = []
    
    try:
        # Detect CSV format by checking first line
        with open(csv_file, 'r', encoding='utf-8-sig') as f:
            first_line = f.readline()
        
        is_clean_csv = ',' in first_line and ';' not in first_line
        
        if is_clean_csv:
            # It's a cleaned CSV format
            with open(csv_file, 'r', encoding='utf-8-sig') as f:
                reader = csv.reader(f, delimiter=',')
                next(reader)  # Skip header
                for row in reader:
                    if len(row) >= 2 and row[0].strip() and row[1].strip():
                        first_name = row[0].strip()
                        surname = row[1].strip()
                        students.append((first_name, surname))
        else:
            # It's a grade sheet format (semicolon-separated)
            with open(csv_file, 'r', encoding='utf-8-sig') as f:
                reader = csv.reader(f, delimiter=';')
                
                # Skip header rows (usually first 2 rows in grade sheets)
                rows = list(reader)
                for i, row in enumerate(rows):
                    # Skip if it's a header or summary row
                    if i < 2:
                        continue
                    if not row or not row[0]:
                        continue
                    if row[0].startswith('Moy.') or 'élèves' in row[0].lower():
                        continue
                    
                    full_name = row[0].strip()
                    if not full_name:
                        continue
                    
                    # Split into parts
                    parts = full_name.split()
                    
                    # In French format: SURNAME(S) First-name(s)
                    # Surnames are ALL CAPS, first names are normal case
                    # We need to find where surnames end and first names begin
                    surname_parts = []
                    first_name_parts = []
                    
                    found_first_name = False
                    for part in parts:
                        # If we find a part that's not all uppercase, we've hit the first name
                        if not part.isupper() or found_first_name:
                            first_name_parts.append(part)
                            found_first_name = True
                        else:
                            # Still in the surname section (all uppercase)
                            surname_parts.append(part)
                    
                    surname = ' '.join(surname_parts)
                    first_name = ' '.join(first_name_parts)
                    
                    # Only add if we found both parts
                    if surname and first_name:
                        students.append((first_name, surname))
        
        # Sort by surname alphabetically
        students.sort(key=lambda x: x[1])
        
    except Exception as e:
        print(f"Error reading CSV file: {e}", file=sys.stderr)
        sys.exit(1)
    
    return students


def create_markdown(students, output_file):
    """Create markdown format comments file."""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Student Comments and Observations\n\n")
        f.write("---\n\n")
        for first, last in students:
            f.write(f"## {first} {last}\n\n")
            f.write("**Classroom observations:**\n\n\n\n")
            f.write("**Areas for improvement:**\n\n\n\n")
            f.write("---\n\n")
    print(f"Created: {output_file}")


def create_text(students, output_file):
    """Create plain text format comments file."""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("STUDENT COMMENTS\n")
        f.write("=" * 60 + "\n\n")
        for first, last in students:
            f.write(f"STUDENT: {first} {last}\n")
            f.write("-" * 60 + "\n\n")
            f.write("Observations:\n\n\n\n")
            f.write("Comments:\n\n\n\n")
            f.write("=" * 60 + "\n\n")
    print(f"Created: {output_file}")


def create_csv(students, output_file):
    """Create CSV format comments file."""
    with open(output_file, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['First Name', 'Surname', 'Observations', 'Progress', 'Comments'])
        for first, last in students:
            writer.writerow([first, last, '', '', ''])
    print(f"Created: {output_file}")


def main():
    """Main function to process arguments and generate output files."""
    # Check for help flag
    if len(sys.argv) < 2 or sys.argv[1] in ['-h', '--help', 'help']:
        show_help()
        sys.exit(0)
    
    input_file = sys.argv[1]
    output_format = sys.argv[2] if len(sys.argv) > 2 else 'md'
    
    if not os.path.exists(input_file):
        print(f"Error: File '{input_file}' not found.", file=sys.stderr)
        sys.exit(1)
    
    # Extract students from CSV
    students = extract_students(input_file)
    
    if not students:
        print("Error: No students found in CSV file.", file=sys.stderr)
        sys.exit(1)
    
    print(f"Found {len(students)} students")
    
    # Generate output filename base
    base_name = Path(input_file).stem
    output_dir = Path.cwd()  # Use current directory instead of input file directory
    
    # Create requested format(s)
    if output_format == 'all':
        create_markdown(students, output_dir / f"comments_{base_name}.md")
        create_text(students, output_dir / f"comments_{base_name}.txt")
        create_csv(students, output_dir / f"comments_{base_name}.csv")
    elif output_format == 'md':
        create_markdown(students, output_dir / f"comments_{base_name}.md")
    elif output_format == 'txt':
        create_text(students, output_dir / f"comments_{base_name}.txt")
    elif output_format == 'csv':
        create_csv(students, output_dir / f"comments_{base_name}.csv")
    else:
        print(f"Error: Unknown format '{output_format}'. Use: md, txt, csv, or all", file=sys.stderr)
        sys.exit(1)
    
    print(f"\nDone! Student comments file(s) created in: {output_dir}")


if __name__ == '__main__':
    main()
