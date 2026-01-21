# Chronos-2 vs Large Bayesian VAR

Comparing **Amazon's Chronos-2** (a pretrained time-series foundation model) against a traditional **Large Bayesian VAR** (Giannone et al., 2015) for US macroeconomic forecasting.

## Overview

**Research Question:** Can a zero-shot foundation model compete with an econometrically rigorous Bayesian VAR on structured macroeconomic data?

### Models

| Model | Type | Reference |
|-------|------|-----------|
| **Chronos-2** | T5-based Transformer foundation model | [Amazon Chronos](https://github.com/amazon-science/chronos-forecasting) |
| **Large BVAR** | Bayesian Vector Autoregression | Giannone, Lenza, Primiceri (2015) |

### Data

- **Source:** Giannone et al. replication dataset
- **Variables:** 7 US macro indicators (Real GDP, Prices, Consumption, Investment, Hours, Compensation, Fed Funds)
- **Frequency:** Quarterly
- **Sample:** 200 observations (1974-2023)

---

## Results

### 8-Quarter Holdout Evaluation

Both models trained on 192 observations, evaluated on final 8 quarters (2022-2023).

#### Overall Performance

| Metric | Chronos-2 | BVAR | Winner |
|--------|-----------|------|--------|
| **Average RMSE** | 2.362 | 2.422 | **Chronos** (+2.5%) |
| **Average MAE** | 2.024 | 2.120 | **Chronos** (+4.5%) |

#### Performance by Variable (RMSE)

| Variable | Chronos | BVAR | Ratio | Winner | Analysis |
|----------|---------|------|-------|--------|----------|
| **RGDP** | 2.64 | 1.63 | 1.62 | **BVAR** | BVAR captures GDP dynamics better; Chronos overshoots |
| **PGDP** | 1.37 | 0.55 | 2.48 | **BVAR** | BVAR dominates on inflation; Chronos overestimates |
| **Cons** | 1.45 | 1.42 | 1.02 | **BVAR** | Near tie; both track consumption well |
| **GPDInv** | 5.84 | 9.46 | 0.62 | **Chronos** | Chronos handles volatility; BVAR misses direction |
| **EmpHours** | 2.50 | 1.70 | 1.47 | **BVAR** | BVAR more accurate on employment |
| **RealCompHour** | 2.37 | 1.82 | 1.30 | **BVAR** | BVAR better on wage dynamics |
| **FedFunds** | 0.35 | 0.37 | 0.94 | **Chronos** | Near tie; Chronos slightly better on rates |

**Summary: BVAR 5/7 variables, Chronos 2/7 variables**

#### Performance by Forecast Horizon

| Horizon | Chronos RMSE | BVAR RMSE | Ratio | Winner | Improvement |
|---------|--------------|-----------|-------|--------|-------------|
| **1Q** | 4.02 | 7.25 | 0.55 | **Chronos** | 45% better |
| **2Q** | 1.84 | 2.85 | 0.65 | **Chronos** | 35% better |
| **3Q** | 1.23 | 1.48 | 0.83 | **Chronos** | 17% better |
| **4Q** | 1.86 | 2.51 | 0.74 | **Chronos** | 26% better |
| **5Q** | 2.38 | 2.72 | 0.87 | **Chronos** | 13% better |
| **6Q** | 2.96 | 3.27 | 0.91 | **Chronos** | 9% better |
| **7Q** | 3.00 | 3.14 | 0.96 | **Chronos** | 4% better |
| **8Q** | 4.16 | 4.24 | 0.98 | **Chronos** | 2% better |

**Summary: Chronos wins ALL 8 horizons, with advantage diminishing at longer horizons**

---

## Detailed Analysis

### Why BVAR Wins on Most Variables

1. **GDP (RGDP):** BVAR errors range from -0.18 to +2.15 percentage points. Chronos consistently overshoots, with errors from +0.35 to +6.62 pp at horizon 1.

2. **Inflation (PGDP):** BVAR tracks the 2-4% inflation remarkably well (errors < 0.6 pp after Q1). Chronos systematically overestimates by 0.5-2.9 pp.

3. **Employment (EmpHours):** The labor market contracted (-0.2% to -2.1% annualized). BVAR predicted modest growth (+0.8-1.2%), while Chronos predicted stronger growth (+1.6-1.9%), further from actuals.

### Why Chronos Wins on Investment

**Investment (GPDInv)** is the critical variable:
- Actual: Highly volatile, ranging from -10% to -7% annualized
- BVAR predicted: +2.8% to +8.7% (completely wrong direction!)
- Chronos predicted: -3.3% to +2.4% (captured negativity early, then mean-reverted)

BVAR's error on Investment at horizon 1: **+18.7 pp** (catastrophic)
Chronos's error on Investment at horizon 1: **+6.8 pp** (still wrong, but much better)

This single variable's RMSE (BVAR: 9.46, Chronos: 5.84) is so large that it dominates the average.

### Why Chronos Wins All Horizons

Despite losing on 5/7 individual variables, Chronos wins every horizon because:
1. **Investment dominates the average RMSE** due to its high volatility
2. **Chronos's short-horizon advantage** (45% better at Q1) is largest where errors matter most
3. **BVAR's directional miss on Investment** compounds across all horizons

### The Paradox Explained

> **Chronos wins on average RMSE but loses on most variables**

This happens because:
- RMSE is sensitive to large errors (squared)
- Investment has the largest errors of any variable
- Chronos has much smaller errors on Investment
- Even though BVAR is better on 5 variables, its Investment errors are so catastrophic they dominate

---

## Key Insights

### When to Use Each Model

| Scenario | Recommended Model | Reason |
|----------|-------------------|--------|
| Forecasting GDP, inflation, employment | **BVAR** | Captures smooth macro dynamics |
| Forecasting volatile series (investment) | **Chronos** | Better at regime changes |
| Short-horizon forecasts (1-4Q) | **Chronos** | 17-45% improvement over BVAR |
| Long-horizon forecasts (5-8Q) | Either | Similar performance |
| When directional accuracy matters | **Chronos** | BVAR can miss turning points |

### Interpretation

1. **BVAR's Minnesota prior** assumes macro variables follow stable AR processes. This works well for GDP, prices, and employment, but fails when investment experiences large swings.

2. **Chronos as a foundation model** may have learned patterns from diverse time series (including volatile financial data), giving it an edge on non-stationary behavior.

3. **The 2022-2023 period** was unusual (post-COVID, high inflation, Fed tightening). BVAR's steady-state assumptions were violated for investment.

---

## Limitations

- **8-Quarter Horizon Only:** BVAR forecasts were pre-computed in MATLAB for 8 horizons. Extending to 20+ quarters requires re-running the BVAR estimation.
- **Single Evaluation Window:** Results are from one pseudo out-of-sample exercise (2022-2023). Rolling origin evaluation would provide more robust estimates.
- **Zero-Shot Only:** Chronos was not fine-tuned on macro data; fine-tuning may improve performance on smooth variables.
- **Unusual Period:** The evaluation period includes post-COVID recovery, which may not generalize.

---

## Installation

This project uses [uv](https://github.com/astral-sh/uv) for dependency management.

```bash
# Clone the repository
git clone https://github.com/iamsurajkumar/chronos-bvar.git
cd chronos-bvar

# Install dependencies (requires uv)
uv sync

# Or install uv first if needed
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Usage

### Run notebooks

```bash
# Activate environment and launch Jupyter
uv run jupyter notebook

# Or use the kernel directly in VSCode/JupyterLab
# Select "Python (chronos-bvar uv)" kernel
```

### Key files

| File | Description |
|------|-------------|
| `model_comparison.ipynb` | Main comparison notebook with RMSE analysis |
| `chronos_replication.ipynb` | Initial exploration and fine-tuning experiments |
| `pyproject.toml` | Project dependencies |

## Methodology

### Chronos-2 Inference
- **Mode:** Multivariate forecasting via AutoGluon TimeSeriesPredictor
- **Approach:** Zero-shot inference using `presets="chronos2"`
- **Output:** Probabilistic forecasts (10th, 50th, 90th percentiles)

### BVAR Benchmark
- **Implementation:** MATLAB (Giannone et al. replication files)
- **Prior:** Minnesota prior with hierarchical hyperparameter estimation

### Evaluation
- **Metrics:** RMSE, MAE
- **Design:** Pseudo out-of-sample (holdout last 8 quarters)
- **Comparison:** Both models trained on identical data (first 192 observations)

## Requirements

- Python 3.11 (required for AutoGluon compatibility)
- Apple Silicon or CUDA GPU recommended

## References

- Giannone, D., Lenza, M., & Primiceri, G. E. (2015). Prior Selection for Vector Autoregressions. *Review of Economics and Statistics*, 97(2), 436-451.
- Ansari, A. F., et al. (2024). Chronos: Learning the Language of Time Series. *arXiv preprint arXiv:2403.07815*.

## License

MIT
