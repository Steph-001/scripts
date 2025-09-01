#!/usr/bin/env python3
import csv
import sys

csv_file = sys.argv[1]
extra_columns = sys.argv[2:]  # Optional extra columns names

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

# Print header
print(fmt_row(headers))
print("|" + "|".join("-"*w for w in col_widths) + "|")

# Print rows
for row in reader[1:]:
    print(fmt_row(row + [""]*len(extra_columns)))

