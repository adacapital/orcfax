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

echo "Collector Directory: $COLLECTOR_PATH"

# Step to create /var/tmp/notused.db for CNT_DB_NAME
echo "Creating unused database file at /var/tmp/notused.db..."
sudo touch /var/tmp/notused.db

# Create the node.env file with the required environment variables
NODE_ENV_FILE="$COLLECTOR_PATH/node.env"
echo "Creating environment file at $NODE_ENV_FILE..."

cat <<EOL > "$NODE_ENV_FILE"
# Environment variables for Orcfax collector node

## Variables used in ITN Phase 1
export ORCFAX_VALIDATOR=
export NODE_IDENTITY_LOC=/home/cardano/data/orcfax/devops/keys/.node-identity.json
export NODE_SIGNING_KEY=
export GOFER=$COLLECTOR_PATH/gofer

# Variables not used in ITN Phase 1 but cannot be null
export CNT_DB_NAME=/var/tmp/notused.db
export OGMIOS_URL=ws://example.com/ogmios
EOL

# Set permissions to secure the node.env file
chmod 600 "$NODE_ENV_FILE"