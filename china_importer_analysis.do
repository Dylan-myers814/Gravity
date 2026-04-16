* =============================================================================
* Graphical analysis: Do productivity differences lead to higher export flows
* to China in 2005? (China as sole importer)
* =============================================================================
* Assumes gravity.dta (or gravity.csv imported) is in the current directory.
* If using .csv: import delimited "gravity.csv", clear

use "gravity.dta", clear

* Restrict: year 2005, China as importer (destination) only
keep if year == 2005 & iso_d == "CHN"

* Drop missing or non-positive flow / GDP per capita
drop if missing(flow) | missing(gdpcap_o) | missing(gdpcap_d)
drop if flow <= 0 | gdpcap_o <= 0 | gdpcap_d <= 0

* Productivity difference: |ln(gdpcap_exporter) - ln(gdpcap_China)|
gen ln_gdpcap_o = ln(gdpcap_o)
gen ln_gdpcap_d = ln(gdpcap_d)
gen log_gdpcap_diff = abs(ln_gdpcap_o - ln_gdpcap_d)

* Log export flow to China
gen log_flow = ln(flow)

* Linear regression: log(export flow) ~ productivity difference
reg log_flow log_gdpcap_diff

* Scatter plot with regression line
twoway (scatter log_flow log_gdpcap_diff) (lfit log_flow log_gdpcap_diff), ///
    title("Export flows to China (2005): productivity difference and bilateral trade") ///
    xtitle("Absolute log GDP per capita difference (exporter vs China)") ///
    ytitle("Log export flow to China") ///
    legend(order(1 "Data" 2 "Linear fit"))

* Optional: save graph
* graph export "china_importer_2005_productivity_flow.png", replace
