"""
Plot log bilateral trade (USA exports) vs absolute log GDP per capita difference.
"""
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Load data and filter USA as origin (exports from USA)
df = pd.read_csv("gravity.csv")
usa = df[df["iso_o"] == "USA"].copy()

# Drop rows with missing flow or GDP per capita (need both origin and destination)
usa = usa.dropna(subset=["flow", "gdpcap_o", "gdpcap_d"])
usa = usa[(usa["flow"] > 0) & (usa["gdpcap_o"] > 0) & (usa["gdpcap_d"] > 0)]

# Log bilateral trade (exports)
usa["log_flow"] = np.log(usa["flow"])

# Absolute log GDP per capita difference
usa["log_gdpcap_diff"] = np.abs(np.log(usa["gdpcap_o"]) - np.log(usa["gdpcap_d"]))

# Linear regression: log_flow ~ log_gdpcap_diff (on full sample)
x = usa["log_gdpcap_diff"].values
y = usa["log_flow"].values
slope, intercept = np.polyfit(x, y, 1)
y_hat = intercept + slope * x
r_sq = 1 - (np.sum((y - y_hat) ** 2) / np.sum((y - y.mean()) ** 2))

# Scatter plot (optionally thin points for visibility if many)
n = len(usa)
if n > 50_000:
    plot_df = usa.sample(n=50_000, random_state=42)
else:
    plot_df = usa

fig, ax = plt.subplots(figsize=(8, 6))
ax.scatter(plot_df["log_gdpcap_diff"], plot_df["log_flow"], alpha=0.3, s=8, c="steelblue", edgecolors="none", label="Data")
x_line = np.linspace(usa["log_gdpcap_diff"].min(), usa["log_gdpcap_diff"].max(), 100)
ax.plot(x_line, intercept + slope * x_line, "r-", lw=2, label=f"Linear fit (R² = {r_sq:.3f}, slope = {slope:.3f})")
ax.set_xlabel("Absolute log GDP per capita difference (|ln(gdpcap_usa) - ln(gdpcap_dest)|)")
ax.set_ylabel("Log bilateral trade (exports, ln(flow))")
ax.set_title("USA exports: log bilateral trade vs absolute log GDP per capita difference")
ax.legend()
ax.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("usa_exports_logflow_vs_log_gdpcap_diff.png", dpi=150, bbox_inches="tight")
plt.close()
print("Saved usa_exports_logflow_vs_log_gdpcap_diff.png")
print(f"Plot includes {len(plot_df):,} points (from {n:,} USA export pairs after dropping missing/zero).")
print(f"Regression: slope = {slope:.4f}, intercept = {intercept:.4f}, R² = {r_sq:.4f}")