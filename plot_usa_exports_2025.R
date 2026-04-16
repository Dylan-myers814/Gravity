# Plot log bilateral trade (USA exports) vs absolute log GDP per capita difference.
# Data restricted to a single year (default: 2006, the latest year in the dataset).
# In RStudio: open this file and use "Source" (Ctrl+Shift+S) to run the whole script.

# Folder containing gravity.csv (use full path so it works regardless of working directory)
FOLDER <- "c:/Users/dylan/Downloads/gravity"
csv_path <- file.path(FOLDER, "gravity.csv")
if (!file.exists(csv_path)) stop("File not found: ", csv_path, " - Edit FOLDER at the top of this script.")

# Year to plot (gravity data has 1948--2006; no 2025)
YEAR <- 2006

# Load data and filter USA as origin (exports from USA) and chosen year
df <- read.csv(csv_path, stringsAsFactors = FALSE)
usa <- df[df$iso_o == "USA" & df$year == YEAR, ]
if (nrow(usa) == 0) stop("No rows with iso_o == 'USA' and year == ", YEAR, " found in gravity.csv.")

# Drop rows with missing or non-positive flow / GDP per capita
usa <- usa[complete.cases(usa[, c("flow", "gdpcap_o", "gdpcap_d")]), ]
usa <- usa[usa$flow > 0 & usa$gdpcap_o > 0 & usa$gdpcap_d > 0, ]
if (nrow(usa) == 0) stop("No USA export rows with valid flow/gdpcap for year ", YEAR, ".")

# Log bilateral trade (exports) and absolute log GDP per capita difference
usa$log_flow <- log(usa$flow)
usa$log_gdpcap_diff <- abs(log(usa$gdpcap_o) - log(usa$gdpcap_d))

# Linear regression: log_flow ~ log_gdpcap_diff
fit <- lm(log_flow ~ log_gdpcap_diff, data = usa)
slope <- coef(fit)["log_gdpcap_diff"]
intercept <- coef(fit)["(Intercept)"]
r_sq <- summary(fit)$r.squared

# Scatter plot with regression line
n <- nrow(usa)
plot(
  usa$log_gdpcap_diff,
  usa$log_flow,
  pch = 16,
  col = adjustcolor("steelblue", alpha.f = 0.5),
  cex = 1,
  xlab = "Absolute log GDP per capita difference (|ln(gdpcap_usa) - ln(gdpcap_dest)|)",
  ylab = "Log bilateral trade (exports, ln(flow))",
  main = paste0("USA exports (", YEAR, "): log bilateral trade vs absolute log GDP per capita difference")
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

# Save plot to PNG
png(file.path(FOLDER, paste0("usa_exports_", YEAR, "_logflow_vs_log_gdpcap_diff.png")), width = 8, height = 6, units = "in", res = 150)
plot(
  usa$log_gdpcap_diff,
  usa$log_flow,
  pch = 16,
  col = adjustcolor("steelblue", alpha.f = 0.5),
  cex = 1,
  xlab = "Absolute log GDP per capita difference (|ln(gdpcap_usa) - ln(gdpcap_dest)|)",
  ylab = "Log bilateral trade (exports, ln(flow))",
  main = paste0("USA exports (", YEAR, "): log bilateral trade vs absolute log GDP per capita difference")
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
cat("Saved usa_exports_", YEAR, "_logflow_vs_log_gdpcap_diff.png\n", sep = "")
cat(sprintf("Plot includes %s points (USA export pairs in %s after dropping missing/zero).\n",
            format(n, big.mark = ","), YEAR))
cat(sprintf("Regression: slope = %.4f, intercept = %.4f, R² = %.4f\n",
            slope, intercept, r_sq))
