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

## Results

### 8-Quarter Holdout Evaluation

Both models trained on 192 observations, evaluated on final 8 quarters.

#### Overall Performance

| Metric | Chronos-2 | BVAR | Winner |
|--------|-----------|------|--------|
| **Average RMSE** | 2.36 | 2.42 | Chronos (+2.5%) |
| **Average MAE** | 2.02 | 2.12 | Chronos (+4.7%) |

#### Performance by Variable

| Variable | Chronos RMSE | BVAR RMSE | Winner | Notes |
|----------|--------------|-----------|--------|-------|
| RGDP | 2.64 | 1.63 | **BVAR** | BVAR 38% better |
| PGDP (Prices) | 1.37 | 0.55 | **BVAR** | BVAR 60% better |
| Consumption | 1.45 | 1.42 | **BVAR** | Nearly tied |
| **Investment** | 5.84 | 9.46 | **Chronos** | Chronos 38% better |
| Employment Hours | 2.50 | 1.70 | **BVAR** | BVAR 32% better |
| Real Compensation | 2.37 | 1.82 | **BVAR** | BVAR 23% better |
| **Fed Funds** | 0.35 | 0.37 | **Chronos** | Chronos 6% better |

**Score: BVAR 5/7 variables, Chronos 2/7 variables**

#### Performance by Horizon

| Horizon | Chronos RMSE | BVAR RMSE | Winner |
|---------|--------------|-----------|--------|
| 1Q | 4.02 | 7.25 | **Chronos** (+45%) |
| 2Q | 1.84 | 2.85 | **Chronos** (+35%) |
| 3Q | 1.23 | 1.48 | **Chronos** (+17%) |
| 4Q | 1.86 | 2.51 | **Chronos** (+26%) |
| 5Q | 2.38 | 2.72 | **Chronos** (+13%) |
| 6Q | 2.96 | 3.27 | **Chronos** (+9%) |
| 7Q | 3.00 | 3.14 | **Chronos** (+4%) |
| 8Q | 4.16 | 4.24 | **Chronos** (+2%) |

**Score: Chronos wins ALL 8 horizons**

### Key Insights

1. **Variable-Level Analysis:**
   - BVAR excels at forecasting "smooth" macro aggregates (GDP, prices, employment)
   - Chronos excels at volatile series (Investment) and interest rates
   - Chronos's large advantage on Investment (38% better) drives its overall win

2. **Horizon Analysis:**
   - Chronos dominates at short horizons (1-4Q), with advantage shrinking at longer horizons
   - BVAR's econometric structure provides more stable long-run forecasts

3. **Interpretation:**
   - The zero-shot foundation model is competitive with domain-specific econometric models
   - BVAR's Minnesota prior is well-suited for stable macro relationships
   - Chronos may capture non-linear patterns BVAR misses (e.g., Investment volatility)

### Limitations

- **8-Quarter Horizon Only:** BVAR forecasts were pre-computed in MATLAB for 8 horizons. Extending to 20+ quarters requires re-running the BVAR estimation.
- **Single Evaluation Window:** Results are from one pseudo out-of-sample exercise. Rolling origin evaluation would provide more robust estimates.
- **Zero-Shot Only:** Chronos was not fine-tuned on macro data; fine-tuning may improve performance.

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
