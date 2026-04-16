# How to produce the one PDF for your assignment

Your assignment asks for **one PDF** containing:

1. The Stata/R code used for the analysis  
2. The graph  
3. Your written explanation of the results  

All of that is in the **R Markdown** report. Follow the steps below to generate the PDF.

---

## Option A: Using RStudio (recommended)

1. **Open RStudio** and set your working directory to the folder that contains `gravity.csv` and the Rmd file:
   - `File → Open Project` and open this folder, or  
   - In the Console: `setwd("c:/Users/dylan/Downloads/gravity")`

2. **Edit the path if needed**  
   Open `China_importer_analysis_report.Rmd` and at the top of the first code chunk change:
   ```r
   FOLDER <- "c:/Users/dylan/Downloads/gravity"
   ```
   to the full path where your `gravity.csv` is located (if different).

3. **Knit to PDF**  
   - Open `China_importer_analysis_report.Rmd`  
   - Click the **Knit** button (or use the dropdown and choose **Knit to PDF**)  
   - If R asks to install packages (`rmarkdown`, `tinytex`, etc.), accept.  
   - The first time you knit to PDF, R may install TinyTeX (a LaTeX distribution); allow it so that PDF output works.

4. **Find your PDF**  
   The file `China_importer_analysis_report.pdf` will appear in the same folder. That PDF contains:
   - The R code used for the analysis  
   - The graph (scatter of log export flow to China vs productivity difference with regression line)  
   - The written explanation of the results  

Upload this single PDF for your assignment.

---

## Option B: If you use Stata instead of R

1. Use the **Stata code** in `china_importer_analysis.do` to run the same analysis and create the graph in Stata.  
2. Copy the code from the .do file into your report.  
3. Export the graph (e.g. `graph export ...`) and paste it into a Word (or similar) document.  
4. Add your written explanation (you can use the “Written explanation” section from `China_importer_analysis_report.Rmd` as a template and adapt the numbers to your Stata output).  
5. Save or print the document as one PDF and upload it.

---

## Files in this folder

| File | Purpose |
|------|--------|
| `China_importer_analysis_report.Rmd` | R Markdown: run this in RStudio and knit to PDF to get the full report. |
| `china_importer_analysis.R` | Standalone R script: same analysis and graph; use if you only want to run the analysis or regenerate the figure. |
| `china_importer_analysis.do` | Stata version of the same analysis and graph. |
| `gravity.csv` | Gravity dataset (must be in the folder specified by `FOLDER` in the R code). |
