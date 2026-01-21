#!/bin/bash
# Create virtual environment
python3 -m venv chronos-env
source chronos-env/bin/activate

# Install dependencies
pip install --upgrade pip
pip install torch
pip install git+https://github.com/amazon-science/chronos-forecasting.git
pip install pandas matplotlib transformers accelerate ipykernel pyarrow
python -m ipykernel install --user --name=chronos-env --display-name "Python (chronos-env)"

echo "Environment setup complete. Activate with 'source chronos-env/bin/activate'"
