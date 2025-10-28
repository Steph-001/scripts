#!/usr/bin/env python3
import csv
import sys
import subprocess
import os

if len(sys.argv) < 2:
    print("Usage: csv_to_md.py <csv_file> [output_name.md] [extra_columns...]")
    sys.exit(1)

csv_file = sys.argv[1]

# Check if second argument is an output filename (ends with .md)
if len(sys.argv) >= 3 and sys.argv[2].endswith('.md'):
    output_filename = sys.argv[2]
    extra_columns = sys.argv[3:]  # Extra columns start from 3rd argument
else:
    output_filename = csv_file.replace('.csv', '.md')
    extra_columns = sys.argv[2:]  # Extra columns start from 2nd argument

# Open CSV once, stripping BOM
with open(csv_file, newline='', encoding='utf-8-sig') as f:
    reader = list(csv.reader(f))

# Prepare header
headers = reader[0] + extra_columns if extra_columns else reader[0]

# Determine column widths
col_widths = [len(h) for h in headers]
for row in reader[1:]:
    for i, val in enumerate(row):
        col_widths[i] = max(col_widths[i], len(val))
for i in range(len(extra_columns)):
    col_widths[len(reader[0])+i] = max(len(extra_columns[i]), 0)

# Format row
def fmt_row(row):
    return "| " + " | ".join(f"{v:<{col_widths[i]}}" for i,v in enumerate(row)) + " |"

# Generate content
content_lines = []
content_lines.append("---")
content_lines.append("tags: []")
content_lines.append("---")
content_lines.append("")
content_lines.append(fmt_row(headers))
# Use same spacing as data rows for separator
content_lines.append("| " + " | ".join("-" * col_widths[i] for i in range(len(headers))) + " |")
for row in reader[1:]:
    content_lines.append(fmt_row(row + [""]*len(extra_columns)))

markdown_content = "\n".join(content_lines)

# Create output file in current directory
with open(output_filename, 'w') as f:
    f.write(markdown_content)

# Open in Neovim with cursor positioned in tags brackets
subprocess.run(['nvim', '+2', '+normal 7l', '+startinsert', output_filename])
