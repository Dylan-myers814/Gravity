# Gravity Trade Analysis

This repository contains scripts and report files for exploratory gravity-model analysis using the `gravity` dataset.

## What This Project Includes

- Country-pair trade data analysis workflows in:
  - `R` (`.R`, `.Rmd`)
  - `Python` (`.py`)
  - `Stata` (`.do`)
- Graphs and report templates for assignment-style writeups.

## Main Files

- `China_importer_analysis_report.Rmd`  
  One-file report template (code + graph + explanation) for:
  - year `2005`
  - China as importer (`iso_d == "CHN"`)
  - relationship between productivity differences and export flows

- `china_importer_analysis.R`  
  Standalone R script for the same China-importer analysis.

- `china_importer_analysis.do`  
  Stata version of the same analysis.

- `plot_usa_exports.py`, `plot_usa_exports.R`  
  USA exporter analysis across all available years.

- `plot_usa_exports_2025.py`, `plot_usa_exports_2025.R`  
  Single-year variant (configured to 2006, the latest year in this data version).

- `GRAVITY_DATASET_REPORT.md`  
  Dataset structure and variable summary.

- `HOW_TO_PRODUCE_PDF.md`  
  Steps to generate an assignment-ready PDF.

## Data Notes

Raw data files are intentionally ignored in git:

- `gravity.csv`
- `gravity.dta`

This keeps the repository lightweight and avoids GitHub large-file limits.

## Quick Start (R)

1. Place `gravity.csv` in your local project folder.
2. Open `China_importer_analysis_report.Rmd` in RStudio.
3. Update the `FOLDER <- "..."` path if needed.
4. Click **Knit to PDF**.

## Quick Start (Stata)

1. Place `gravity.dta` (or import `gravity.csv`) in your working directory.
2. Run `china_importer_analysis.do`.
3. Export the graph and include results in your report.

## Scope

These scripts are designed for coursework/exploratory analysis and emphasize transparent, reproducible steps rather than production packaging.
