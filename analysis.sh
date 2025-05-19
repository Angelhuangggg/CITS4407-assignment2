#! /bin/bash

# Usage: ./analysis.sh <filename>

filename="$1"

# Step 0: Check if file exists and is not empty
if [[ ! -s "$filename" ]]; then
    echo "Error: File '$filename' does not exist or is empty."
    exit 1
fi

# step1: analyze the most popular's game mechanics
# - Mechanics are in column 13 and may contain multiple comma-separated items
# - We split and trim each mechanic, and count occurrences across all games
awk -F $'\t' '
length($13) > 0 && NR != 1 {
    n = split($13, arr, ",")
    for (i = 1; i <= n; i++) {
        gsub(/^ +| +$/, "", arr[i])
        dict[arr[i]]++
    }
}
END {
    max = 0;
    max_id = "";
    for (k in dict) {
        if (dict[k] > max) {
            max = dict[k];
            max_id = k;
        }
    }
    print "The most popular game mechanics is:", max_id, "appearing in", max, "games";
}
' "$1"

# step2: analyze the most popular's game domains
# - Domains are in column 14, also comma-separated
# - We perform similar counting to identify the most common domain type
awk -F $'\t' '
length($14) > 0 && NR != 1 {
    n = split($14, arr, ",")
    for (i = 1; i <= n; i++) {
        gsub(/^ +| +$/, "", arr[i])
        dict[arr[i]]++
    }
}
END {
    max = 0;
    max_id = "";
    for (k in dict) {
        if (dict[k] > max) {
            max = dict[k];
            max_id = k;
        }
    }
    print "The most popular game domain is:", max_id, "appearing in", max, "games";
}
' "$1"

# step3: caculate the correlation between the average scores and the year
awk -F $'\t' '
BEGIN {
    x=3
    y=9
}
NR > 1 && $x ~ /^[0-9.]+$/ && $y ~ /^[0-9.]+$/ {  
# To ensure the robustness of the correlation calculation, we exclude any rows where the selected columns (x and y) are empty or contain non-numeric values. This prevents invalid data from skewing results or causing computation errors.
    n++
    x_sum+=$x
    y_sum+=$y
    x2_sum+=($x*$x)
    y2_sum+=($y*$y)
    xy_sum+=($x*$y)
}
END {
    x_avg=x_sum/n
    y_avg=y_sum/n
    r=(n*xy_sum-x_sum*y_sum)/sqrt((n*x2_sum-x_sum^2)*(n*y2_sum-y_sum^2))
    printf "The correlation between the average scores and the year is %.3f\n", r;
}' "$1"

# step4: caculate the correlation between the average scores and the complexity
awk -F $'\t' '
BEGIN {
    x=11
    y=9
}
NR > 1 && $x ~ /^[0-9.]+$/ && $y ~ /^[0-9.]+$/ {
# To ensure the robustness of the correlation calculation, we exclude any rows where the selected columns (x and y) are empty or contain non-numeric values. This prevents invalid data from skewing results or causing computation errors.
    n++
    x_sum+=$x
    y_sum+=$y
    x2_sum+=($x*$x)
    y2_sum+=($y*$y)
    xy_sum+=($x*$y)
}
END {
    x_avg=x_sum/n
    y_avg=y_sum/n
    r=(n*xy_sum-x_sum*y_sum)/sqrt((n*x2_sum-x_sum^2)*(n*y2_sum-y_sum^2))
    printf "The correlation between the average scores and the complexity is %.3f\n", r;
}' "$1"