# =============================================================================
# Graphical analysis: Do productivity differences lead to higher export flows
# to China in 2005? (China as sole importer)
# =============================================================================

# Setup: use full path so script works regardless of working directory
FOLDER <- "c:/Users/dylan/Downloads/gravity"
csv_path <- file.path(FOLDER, "gravity.csv")

# Load data
df <- read.csv(csv_path, stringsAsFactors = FALSE)

# Restrict: year 2005, China as importer (destination) only
df <- df[df$year == 2005 & df$iso_d == "CHN", ]

# Drop rows with missing or non-positive flow / GDP per capita (both exporter and China)
df <- df[complete.cases(df[, c("flow", "gdpcap_o", "gdpcap_d")]), ]
df <- df[df$flow > 0 & df$gdpcap_o > 0 & df$gdpcap_d > 0, ]

# Productivity difference: absolute difference in log GDP per capita
# (exporter vs China). Higher = larger productivity/income gap.
df$log_gdpcap_diff <- abs(log(df$gdpcap_o) - log(df$gdpcap_d))

# Log export flow (exports to China)
df$log_flow <- log(df$flow)

# Linear regression: log(export flow) ~ productivity difference
fit <- lm(log_flow ~ log_gdpcap_diff, data = df)
slope <- coef(fit)["log_gdpcap_diff"]
intercept <- coef(fit)["(Intercept)"]
r_sq <- summary(fit)$r.squared

# Scatter plot with regression line
plot(
  df$log_gdpcap_diff,
  df$log_flow,
  pch = 16,
  col = adjustcolor("darkblue", alpha.f = 0.6),
  cex = 1.2,
  xlab = "Absolute log GDP per capita difference (exporter vs China)",
  ylab = "Log export flow to China",
  main = "Export flows to China (2005): productivity difference and bilateral trade"
)
abline(fit, col = "red", lwd = 2)
legend(
  "topright",
  legend = sprintf("Linear fit: slope = %.3f, R² = %.3f", slope, r_sq),
  col = "red",
  lty = 1,
  lwd = 2
)
grid()

# Save graph to PNG (for inclusion in report)
png(
  file.path(FOLDER, "china_importer_2005_productivity_flow.png"),
  width = 8,
  height = 6,
  units = "in",
  res = 150
)
plot(
  df$log_gdpcap_diff,
  df$log_flow,
  pch = 16,
  col = adjustcolor("darkblue", alpha.f = 0.6),
  cex = 1.2,
  xlab = "Absolute log GDP per capita difference (exporter vs China)",
  ylab = "Log export flow to China",
  main = "Export flows to China (2005): productivity difference and bilateral trade"
)
abline(fit, col = "red", lwd = 2)
legend(
  "topright",
  legend = sprintf("Linear fit: slope = %.3f, R² = %.3f", slope, r_sq),
  col = "red",
  lty = 1,
  lwd = 2
)
grid()
dev.off()

# Summary
cat("Sample: ", nrow(df), " exporter countries with valid data (China importer, 2005).\n")
cat("Regression: slope = ", round(slope, 4), ", R² = ", round(r_sq, 4), "\n")
