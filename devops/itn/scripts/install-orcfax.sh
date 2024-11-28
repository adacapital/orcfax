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
echo -n "Are you ready for the installation with the details above (y/n)? "
read -r CONFIRMATION
if [[ "$CONFIRMATION" != "y" && "$CONFIRMATION" != "Y" ]]; then
    echo "Installation aborted."
    exit 1
fi

# Create the collector directory
mkdir -p "$COLLECTOR_PATH"
cd "$COLLECTOR_PATH"

# Install Python 3 and venv if not already installed
sudo apt update
sudo apt install -y python3 python3-venv python3-pip

# Create a Python virtual environment
python3 -m venv "$VENV_NAME"

# Activate the virtual environment
source "$VENV_NAME/bin/activate"

# Upgrade pip within the virtual environment
pip install --upgrade pip

# Download the latest collector node wheel file
COLLECTOR_NODE_WHEEL_URL="https://github.com/orcfax/collector-node/releases/download/2.0.1/collector_node-2.0.1rc1-py3-none-any.whl"
wget "$COLLECTOR_NODE_WHEEL_URL" -O collector_node-2.0.1rc1-py3-none-any.whl

# Install the collector node package
pip install ./collector_node-2.0.1rc1-py3-none-any.whl

Download the latest cer-feeds.json
CER_FEEDS_URL="https://raw.githubusercontent.com/orcfax/cer-feeds/main/feeds/preview/cer-feeds.json"
wget "$CER_FEEDS_URL" -O cer-feeds.json

# Download the Gofer binary for ARM64 architecture
GOFER_BINARY_URL="https://github.com/orcfax/oracle-suite/releases/download/0.5.0/gofer_0.5.0_Linux_arm64"
wget "$GOFER_BINARY_URL" -O gofer
chmod +x gofer

# Generate the node-identity.json file
./gofer data ADA/USD -o orcfax

# Schedule the collector node to run via cron every minute
pm2 start bash --name "orcfax-collector" --cron "* * * * *" -- -c "source /home/cardano/data/orcfax/collector/node.env && source /home/cardano/data/orcfax/collector/orcfax-venv/bin/activate && collector-node --feeds \$COLLECTOR_PATH/cer-feeds.json 2>&1"
# pm2 start bash --name "orcfax-collector" --cron "* * * * *" -- -c "source /home/cardano/data/orcfax/collector/node.env && source /home/cardano/data/orcfax/collector/orcfax-venv/bin/activate && collector-node --feeds /home/cardano/data/orcfax/collector/cer-feeds.json 2>&1"



echo "Installation and setup completed successfully!"

# source node.env && source orcfax-venv/bin/activate && collector-node --feeds cer-feeds.json