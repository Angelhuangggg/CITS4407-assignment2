# CITS4407 Assignment 2 - Game Analysis

## Author
Student: Anqi Huang  
 Student ID: 23824496

## Overview

This assignment involves writing a set of shell scripts to process and analyze a dataset of games. The focus is on data cleaning, shell scripting, Git version control, and statistical analysis using only Unix tools.

## Files

- `empty_cells.sh`: Counts empty cells in each column of the dataset.
- `preprocess.sh`: Cleans the dataset (newline conversion, ID fixing, encoding, etc.)
- `analysis.sh`: Answers four research questions (most popular mechanic/domain, two correlations).

## Usage

```bash
./empty_cells.sh bgg_dataset.csv ";"
./preprocess.sh bgg_dataset.csv > cleaned_data.tsv
./analysis.sh cleaned_data.tsv 
