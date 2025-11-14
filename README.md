# Multilevel Exploratory Factor Analysis (EFA) on ESM Data from the Netherlands Twin Register (NTR)

This repository contains an R-based workflow to perform **Multilevel Exploratory Factor Analysis (EFA)** on Experience Sampling Method (ESM) data collected by the [Netherlands Twin Register (NTR)](https://tweelingenregister.vu.nl/).

The goal is to uncover latent affective structures both **between individuals** and **within individuals across days**, using multilevel psychometric techniques.

---

## Project Goals

- **Between-Person Analysis**  
  Identify stable individual differences by averaging item responses per person. This analysis reveals how people differ from each other in general affective tendencies.

- **Within-Person Analysis (Person-by-Day)**  
  Assess how affect fluctuates **within** each individual across different days. This allows exploration of whether the factor structure found between individuals also holds within individuals.

- **Multilevel EFA**  
  Perform EFA at both levels and compare structures to examine cross-level stability in affective dimensions.

---

## Method Overview

### 1. Data Preparation
- Import raw ESM CSV data
- Rename item variables for readability
- Convert to long format for flexibility in aggregation

### 2. EFA Suitability Checks
- **Kaiser-Meyer-Olkin (KMO)** measure of sampling adequacy
- **Bartlett's test of sphericity** to verify sufficient item intercorrelations

### 3. Factor Extraction
- Estimate eigenvalues and scree plots
- Conduct parallel analysis (optional)
- Extract factors using `psych::fa()` (e.g., maximum likelihood)

### 4. Factor Rotation
- **Varimax** (orthogonal, uncorrelated factors)
- **Oblimin** (oblique, correlated factors)

### 5. Interpretation
- Review factor loadings
- Identify simple structure
- Eliminate weak or cross-loading items (if necessary)

### 6. (Optional) Confirmatory Factor Analysis
- Translate EFA structure into a CFA model using `lavaan`
- Evaluate model fit (RMSEA, CFI, TLI, etc.)

---

## Data Source

This workflow was inspired by data collected in the [Netherlands Twin Register (NTR)](https://tweelingenregister.vu.nl/), which maintains a large-scale database of twins and their relatives.

**Note**: This repository uses simulated or anonymized data. Access to real NTR data requires permission.

---

## R Package Dependencies

Make sure the following R packages are installed:

```r
install.packages(c(
  "tidyverse", "readr", "ggplot2", "readxl",
  "lubridate", "lavaan", "tcltk", "ggcorrplot",
  "corrr", "psych"
))
