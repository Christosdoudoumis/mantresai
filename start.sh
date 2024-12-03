#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to display messages
function echo_info {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

function echo_error {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

# Check for Python 3 installation
if ! command -v python3 &> /dev/null
then
    echo_error "Python3 could not be found. Please install Python3 before running this script."
    exit 1
fi

# Define the virtual environment directory
VENV_DIR="venv"

# Create a virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo_info "Creating a virtual environment..."
    python3 -m venv $VENV_DIR
else
    echo_info "Virtual environment already exists."
fi

# Activate the virtual environment
echo_info "Activating the virtual environment..."
source $VENV_DIR/bin/activate

# Upgrade pip to the latest version
echo_info "Upgrading pip..."
pip install --upgrade pip

# Install project dependencies
if [ -f "requirements.txt" ]; then
    echo_info "Installing dependencies from requirements.txt..."
    pip install -r requirements.txt
else
    echo_error "requirements.txt not found. Please ensure it exists in the project directory."
    deactivate
    exit 1
fi

# Set environment variables
export FLASK_APP=app.py
export FLASK_ENV=production  # Change to 'development' if needed

# Optionally, set any other necessary environment variables here
# export GROQ_API_KEY="your_api_key_here"

# Run the Flask application
echo_info "Starting the Flask application..."
python app.py
