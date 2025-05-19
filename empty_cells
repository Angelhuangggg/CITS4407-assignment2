#!/bin/bash

# Usage: ./empty_cells.sh <filename>

filename="$1"
sep=";"  # Fixed separator: semicolon

# Check if file exists and is not empty
if [[ ! -s "$filename" ]]; then
    echo "Error: File '$filename' does not exist or is empty."
    exit 1
fi

# Create a temporary file with cleaned content:
# - remove UTF-8 BOM if present
# - convert Windows CRLF line endings to Unix LF
tempfile=$(mktemp)
tail -c +1 "$filename" \
  | sed '1s/^\xEF\xBB\xBF//' \
  | sed 's/\r$//' > "$tempfile"

# Read the header line and split it into an array of column names
IFS="$sep" read -r -a headers < "$tempfile"
col_count="${#headers[@]}"

# Iterate over each column index
for ((col=1; col<=col_count; col++)); do
    header="${headers[$((col - 1))]}"
    if [[ -z "$header" ]]; then
        header="UNKNOWN_COLUMN_$col"
    fi

    # Use awk to count the number of empty cells in the given column
    awk -v col="$col" -F "$sep" -v name="$header" -v total="$col_count" '
    BEGIN {
        count = 0  # initialize counter for empty cells
    }
    NR > 1 {
        # Skip this row if it does not have enough fields (possible trailing separator)
        if (NF < col)
            next

        # If the value in the column is empty or contains only spaces/tabs, count it
        if ($col ~ /^[ \t]*$/)
            count++
    }
    END {
        # Print the column name and the total number of empty cells
        printf "%-20s: %d\n", name, count
    }' "$tempfile"
done

# Delete the temporary file
rm -f "$tempfile"
