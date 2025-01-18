#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Dynamically determine the base folder of the script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

# Variables for paths and directory names
ROOT_PATH="$BASE_DIR"  # Dynamically constructed root path
COLLECTOR_DIR_NAME="collector"  # Change this to specify a different directory name
VENV_NAME="orcfax-venv"  # Name of the virtual environment
COLLECTOR_PATH="$ROOT_PATH/$COLLECTOR_DIR_NAME"

# Print configuration
echo "Root Path: $ROOT_PATH"
echo "Collector Directory: $COLLECTOR_PATH"
echo "Virtual Environment Name: $VENV_NAME"

# Prompt user confirmation
echo -n "Are you ready for to generate your identity file (y/n)? "
read -r CONFIRMATION
if [[ "$CONFIRMATION" != "y" && "$CONFIRMATION" != "Y" ]]; then
    echo "File generation aborted."
    exit 1
fi

# Create the collector directory
mkdir -p "$COLLECTOR_PATH"
cd "$COLLECTOR_PATH"

# Activate the virtual environment
source "$VENV_NAME/bin/activate"

# Generate the node-identity.json file
./gofer data ADA/USD -o orcfax

sudo cat /tmp/.node-identity.json

cp /tmp/.node-identity.json $ROOT_PATH/devops/keys

echo "Node identity file created!"