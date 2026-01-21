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

## Installation

This project uses [uv](https://github.com/astral-sh/uv) for dependency management.

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/chronos-bvar.git
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
- **Comparison:** Both models trained on identical data

## Results

See `model_comparison.ipynb` for detailed results including:
- Variable-by-variable RMSE comparison
- Horizon-by-horizon error analysis
- Visualization of forecasts with confidence intervals

## Requirements

- Python 3.11 (required for AutoGluon compatibility)
- Apple Silicon or CUDA GPU recommended

## References

- Giannone, D., Lenza, M., & Primiceri, G. E. (2015). Prior Selection for Vector Autoregressions. *Review of Economics and Statistics*, 97(2), 436-451.
- Ansari, A. F., et al. (2024). Chronos: Learning the Language of Time Series. *arXiv preprint arXiv:2403.07815*.

## License

MIT
