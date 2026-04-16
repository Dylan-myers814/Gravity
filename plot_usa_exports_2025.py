"""
Plot log bilateral trade (USA exports) vs absolute log GDP per capita difference.
Data restricted to a single year (default: 2006, the latest year in the dataset).
"""
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Year to plot (gravity data has 1948--2006; no 2025)
YEAR = 2006

# Load data and filter USA as origin (exports from USA) and chosen year
df = pd.read_csv("gravity.csv")
usa = df[(df["iso_o"] == "USA") & (df["year"] == YEAR)].copy()

# Drop rows with missing flow or GDP per capita (need both origin and destination)
usa = usa.dropna(subset=["flow", "gdpcap_o", "gdpcap_d"])
usa = usa[(usa["flow"] > 0) & (usa["gdpcap_o"] > 0) & (usa["gdpcap_d"] > 0)]

if len(usa) == 0:
    raise SystemExit(f"No USA export rows with valid flow/gdpcap for year {YEAR}. Check if {YEAR} exists in the data.")

# Log bilateral trade (exports)
usa["log_flow"] = np.log(usa["flow"])

# Absolute log GDP per capita difference
usa["log_gdpcap_diff"] = np.abs(np.log(usa["gdpcap_o"]) - np.log(usa["gdpcap_d"]))

# Linear regression: log_flow ~ log_gdpcap_diff (on 2025 sample)
x = usa["log_gdpcap_diff"].values
y = usa["log_flow"].values
slope, intercept = np.polyfit(x, y, 1)
y_hat = intercept + slope * x
r_sq = 1 - (np.sum((y - y_hat) ** 2) / np.sum((y - y.mean()) ** 2))

# Scatter plot
fig, ax = plt.subplots(figsize=(8, 6))
ax.scatter(usa["log_gdpcap_diff"], usa["log_flow"], alpha=0.5, s=20, c="steelblue", edgecolors="none", label="Data")
x_line = np.linspace(usa["log_gdpcap_diff"].min(), usa["log_gdpcap_diff"].max(), 100)
ax.plot(x_line, intercept + slope * x_line, "r-", lw=2, label=f"Linear fit (R² = {r_sq:.3f}, slope = {slope:.3f})")
ax.set_xlabel("Absolute log GDP per capita difference (|ln(gdpcap_usa) - ln(gdpcap_dest)|)")
ax.set_ylabel("Log bilateral trade (exports, ln(flow))")
ax.set_title(f"USA exports ({YEAR}): log bilateral trade vs absolute log GDP per capita difference")
ax.legend()
ax.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig(f"usa_exports_{YEAR}_logflow_vs_log_gdpcap_diff.png", dpi=150, bbox_inches="tight")
plt.close()
print(f"Saved usa_exports_{YEAR}_logflow_vs_log_gdpcap_diff.png")
print(f"Plot includes {len(usa):,} points (USA export pairs in {YEAR} after dropping missing/zero).")
print(f"Regression: slope = {slope:.4f}, intercept = {intercept:.4f}, R² = {r_sq:.4f}")
