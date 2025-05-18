#!/bin/bash

# Usage: ./preprocess.sh <filename>

filename="$1"

# Step 0: Check if file exists and is not empty
if [[ ! -s "$filename" ]]; then
    echo "Error: File '$filename' does not exist or is empty."
    exit 1
fi

# Step 1: Remove UTF-8 BOM if present, remove \r, and store in a temp file
tempfile=$(mktemp)
tail -c +1 "$filename" \
  | sed '1s/^\xEF\xBB\xBF//' \
  | sed 's/\r$//' > "$tempfile"

# Step 2: Convert semicolon to tab and store in next file
tempfile2=$(mktemp)
tr ';' '\t' < "$tempfile" > "$tempfile2"

# Step 3: Convert number formats like "1,23" into "1.23"
tempfile3=$(mktemp)
sed -E 's/([0-9]),([0-9])/\1.\2/g' "$tempfile2" > "$tempfile3"

# Step 4: Remove all non-ASCII characters (macOS-compatible using tr)
tempfile4=$(mktemp)
LC_CTYPE=C tr -cd '\000-\177' < "$tempfile3" > "$tempfile4"

# Step 5: Extract the maximum ID from the original file (skip header)
max_id=$(tail -n +2 "$filename" | cut -d ";" -f 1 | sort -k 1 -n -r | head -1)

# Step 6: Fill in missing IDs in first column, output CSV format
awk -F $'\t' -v max_id="$max_id" 'BEGIN { OFS="\t" }
    length($1) == 0 { $1 = ++max_id }
    { print $0 }
' "$tempfile4"

# Step 7: Clean up temporary files
rm -f "$tempfile" "$tempfile2" "$tempfile3" "$tempfile4"
