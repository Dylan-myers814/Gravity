# Gravity Dataset Report

## 1. Overview

This is a **bilateral trade gravity dataset**: each row is a **dyad–year** (origin country, destination country, year). It is typical of datasets used to estimate gravity equations of trade (e.g. trade flow as a function of GDP, distance, and other bilateral characteristics).

| Item | Value |
|------|--------|
| **Rows** | 1,204,671 |
| **Columns** | 36 |
| **Year range** | 1948 – 2006 |
| **Unique years** | 59 |
| **Unique origin countries (iso_o)** | 208 |
| **Unique destination countries (iso_d)** | 208 |

---

## 2. Variable List and Description

### 2.1 Identifiers and time

| Variable | Description |
|----------|-------------|
| **year** | Calendar year (1948–2006). |
| **iso_o** | Origin country (exporter), ISO 3-letter code (e.g. USA, ABW). |
| **iso_d** | Destination country (importer), ISO 3-letter code. |
| **iso2_o** | Origin country, ISO 2-letter code. |
| **iso2_d** | Destination country, ISO 2-letter code. |

### 2.2 Geography and distance

| Variable | Description |
|----------|-------------|
| **distw** | Bilateral distance (population-weighted or similar); in km. Present for all rows. |
| **contig** | Contiguity: 1 if origin and destination share a land border, 0 otherwise. ~2% of pairs are contiguous. |

### 2.3 Culture and institutions

| Variable | Description |
|----------|-------------|
| **comlang_off** | Common official language: 1 if the pair shares an official language, 0 otherwise. ~18% of pairs = 1. |
| **comleg** | Common legal system (binary). |
| **comcur** | Common currency (binary). |
| **family** | Legal family or colonial link (e.g. country code like NLD). |

### 2.4 Origin country (exporter)

| Variable | Description |
|----------|-------------|
| **pop_o** | Origin population. Non-missing in ~94% of rows. |
| **gdp_o** | Origin GDP. Non-missing in ~86% of rows. |
| **gdpcap_o** | Origin GDP per capita. Non-missing in ~86% of rows. |
| **heg_o** | Hegemon / major power indicator for origin (binary). |
| **gatt_o** | Origin is GATT/WTO member (1) or not (0). |

### 2.5 Destination country (importer)

| Variable | Description |
|----------|-------------|
| **pop_d** | Destination population. Non-missing in ~97% of rows. |
| **gdp_d** | Destination GDP. Non-missing in ~90% of rows. |
| **gdpcap_d** | Destination GDP per capita. Non-missing in ~90% of rows. |
| **heg_d** | Hegemon / major power indicator for destination (binary). |
| **gatt_d** | Destination is GATT/WTO member (1) or not (0). |

### 2.6 Trade policy and agreements

| Variable | Description |
|----------|-------------|
| **rta** | Regional trade agreement: 1 if the pair has an RTA in force, 0 otherwise. ~3% of rows = 1. |
| **acp_to_eu** | ACP (African, Caribbean, Pacific) to EU preference (binary). |
| **gsp** | Generalized System of Preferences (binary). |
| **eu_to_acp** | EU to ACP (binary). |
| **gsp_rec** | GSP recipient (binary). |

### 2.7 Colonial and conflict

| Variable | Description |
|----------|-------------|
| **col_to** | Colony (direction) dummy. |
| **col_fr** | Colony (from) dummy. |
| **col_hist** | Colonial history (binary). |
| **col_cur** | Current colony (binary). |
| **indepdate** | Independence date–related (e.g. years since independence). |
| **conflict** | Conflict indicator (binary). |
| **sib_conflict** | Sibling / related conflict (numeric). |
| **sever** | Severity (e.g. of conflict). |

### 2.8 Outcome and validation

| Variable | Description |
|----------|-------------|
| **flow** | Bilateral trade flow (exports from origin to destination). Present for all rows; **709,573** rows have **positive** flow. Units are typically millions USD or similar. |
| **validmirror** | Validation / mirror flow flag (e.g. 0/1 for reporting consistency). |

---

## 3. Data Quality and Coverage

### 3.1 Missing data (key variables)

| Variable | Non-missing share | Note |
|----------|-------------------|------|
| flow | 100% | All rows have a value; many are zero. |
| distw | 100% | No missing distance. |
| pop_d, pop_o | ~94–97% | Good coverage. |
| gdp_d, gdpcap_d | ~90% | Some missing for small/early years. |
| gdp_o, gdpcap_o | ~85–86% | Slightly more missing at origin. |

### 3.2 Trade flow (flow)

- **Positive flow:** 709,573 observations (~59% of rows) have flow > 0.
- **Range (positive flow):** from about 1e-08 to ~348,421 (likely in millions USD or similar unit).
- **Median (positive flow):** ~2.23.

So the dataset is a **full dyad–year panel** (all pairs × years in scope), with many zero or very small flows; analyses often use only positive flows or use models that allow zeros (e.g. Poisson, two-part).

### 3.3 Binary indicators (summary)

- **contig:** ~2.0% of pairs contiguous.
- **comlang_off:** ~18% share official language.
- **rta:** ~2.7% in an RTA.
- **gatt_o / gatt_d:** Mix of 0/1 across years and countries (GATT/WTO membership).

---

## 4. Typical Uses

- **Gravity equation:** Regress log(flow) on log(GDP), log(distance), contiguity, common language, RTA, and other bilateral/country controls.
- **Single-country exports/imports:** Restrict to `iso_o == "USA"` (US exports) or `iso_d == "USA"` (US imports).
- **Single year:** Restrict to one year (e.g. 2006) for cross-section or maps.
- **Panel:** Use year and/or origin/destination fixed effects.

---

## 5. File and Units

- **File:** `gravity.csv` (derived from `gravity.dta`).
- **Units:** Flow and GDP variables are likely in **millions of USD** (or similar); distance in **km**. Confirm from original source if needed for publication.
- **Source style:** Structure and variables are consistent with **CEPII-style gravity datasets** (bilateral trade, distance, GDP, RTA, GATT, etc.). This file appears to be a version covering 1948–2006 with 208 countries.

---

*Report generated from `gravity.csv` in the project folder.*
