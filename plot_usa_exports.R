# Plot log bilateral trade (USA exports) vs absolute log GDP per capita difference.
# In RStudio: open this file and use "Source" (Ctrl+Shift+S) to run the whole script.

# Folder containing gravity.csv (use full path so it works regardless of working directory)
FOLDER <- "c:/Users/dylan/Downloads/gravity"
csv_path <- file.path(FOLDER, "gravity.csv")
if (!file.exists(csv_path)) stop("File not found: ", csv_path, " - Edit FOLDER at the top of this script.")

# Load data and filter USA as origin (exports from USA)
df <- read.csv(csv_path, stringsAsFactors = FALSE)
usa <- df[df$iso_o == "USA", ]
if (nrow(usa) == 0) stop("No rows with iso_o == 'USA' found in gravity.csv.")

# Drop rows with missing or non-positive flow / GDP per capita
usa <- usa[complete.cases(usa[, c("flow", "gdpcap_o", "gdpcap_d")]), ]
usa <- usa[usa$flow > 0 & usa$gdpcap_o > 0 & usa$gdpcap_d > 0, ]

# Log bilateral trade (exports) and absolute log GDP per capita difference
usa$log_flow <- log(usa$flow)
usa$log_gdpcap_diff <- abs(log(usa$gdpcap_o) - log(usa$gdpcap_d))

# Linear regression: log_flow ~ log_gdpcap_diff
fit <- lm(log_flow ~ log_gdpcap_diff, data = usa)
slope <- coef(fit)["log_gdpcap_diff"]
intercept <- coef(fit)["(Intercept)"]
r_sq <- summary(fit)$r.squared

# Guard: ensure data was created (run the whole script with Source, not just part of it)
if (!exists("usa")) stop("Object 'usa' not found. Run the entire script from the top (e.g. in RStudio click Source or Ctrl+Shift+S).")

# Optional: subsample for faster plotting if many points (base R scatter can be slow)
n <- nrow(usa)
if (n > 50000) {
  set.seed(42)
  plot_df <- usa[sample(n, 50000), ]
} else {
  plot_df <- usa
}

# Scatter plot with regression line
plot(
  plot_df$log_gdpcap_diff,
  plot_df$log_flow,
  pch = 16,
  col = adjustcolor("steelblue", alpha.f = 0.3),
  cex = 0.6,
  xlab = "Absolute log GDP per capita difference (|ln(gdpcap_usa) - ln(gdpcap_dest)|)",
  ylab = "Log bilateral trade (exports, ln(flow))",
  main = "USA exports: log bilateral trade vs absolute log GDP per capita difference"
)
abline(fit, col = "red", lwd =2)
legend(
  "topright",
  legend = sprintf("Linear fit (R² = %.3f, slope = %.3f)", r_sq, slope),
  col = "red",
  lty = 1,
  lwd = 2
)
grid()

# Save plot to PNG (optional; comment out if you only want to view in RStudio)
png(file.path(FOLDER, "usa_exports_logflow_vs_log_gdpcap_diff.png"), width = 8, height = 6, units = "in", res = 150)
plot(
  plot_df$log_gdpcap_diff,
  plot_df$log_flow,
  pch = 16,
  col = adjustcolor("steelblue", alpha.f = 0.3),
  cex = 0.6,
  xlab = "Absolute log GDP per capita difference (|ln(gdpcap_usa) - ln(gdpcap_dest)|)",
  ylab = "Log bilateral trade (exports, ln(flow))",
  main = "USA exports: log bilateral trade vs absolute log GDP per capita difference"
)
abline(fit, col = "red", lwd = 2)
legend(
  "topright",
  legend = sprintf("Linear fit (R² = %.3f, slope = %.3f)", r_sq, slope),
  col = "red",
  lty = 1,
  lwd = 2
)
grid()
dev.off()

# Print summary
cat("Saved usa_exports_logflow_vs_log_gdpcap_diff.png\n")
cat(sprintf("Plot includes %s points (from %s USA export pairs after dropping missing/zero).\n",
            format(nrow(plot_df), big.mark = ","),
            format(n, big.mark = ",")))
cat(sprintf("Regression: slope = %.4f, intercept = %.4f, R² = %.4f\n",
            slope, intercept, r_sq))
