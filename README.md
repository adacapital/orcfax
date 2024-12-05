# Orcfax Collector Setup and Automation

This repository contains scripts and resources to help the community set up and automate the **Orcfax Collector Node**. The scripts are designed for flexibility, ensuring compatibility with various environments, including ARM-based Ubuntu systems like Oracle Cloud Infrastructure (OCI) VMs.

## Features
- Automates the setup of the Orcfax Collector Node and its dependencies.
- Provides scheduling options using **PM2** for enhanced process management.
- Ensures clean and reusable configurations via an environment file (`node.env`).
- Supports logging with integration into PM2 or system-level logs via `logger`.

## Prerequisites
Before using these scripts, ensure you have the following installed:
- Python 3 (with `venv` and `pip`)
- PM2 (Node.js process manager)
- wget (for downloading dependencies)

## How to Use

### 1. Clone the Repository
Clone the repository and navigate to the scripts directory.

```bash
git clone https://github.com/adacapital/orcfax.git
```

### 2. Run the Installation Script
The main script installs the Orcfax Collector Node, its dependencies, and configuration files. Ensure you run it with appropriate permissions.

```bash
cd orcfax/devops/itn/scripts
./install-orcfax.sh
```

### 3. Configure Environment Variables
The `node.env` file will be automatically generated. Edit this file to provide necessary details:
- `ORCFAX_VALIDATOR`: URL of the validator to use.
- `NODE_SIGNING_KEY`: Path to your signing key file.
- `GOFER`: Path to the `gofer` binary (already set by the script).
- Other variables are pre-configured for ITN Phase 1.

### 4. Schedule the Collector-Node with PM2
Start and schedule the collector-node process using PM2. Save the PM2 configuration to ensure it restarts on system reboots.


```bash
pm2 start bash --name "orcfax-collector" --cron "* * * * *" -- -c "source \$COLLECTOR_PATH/node.env && source \$COLLECTOR_PATH/orcfax-venv/bin/activate && collector-node --feeds \$COLLECTOR_PATH/cer-feeds.json 2>&1"

pm2 save
pm2 startup
```
### 5. Verify the Process
Use PM2 to check the status and logs of the `collector-node` process.


```bash
pm2 list
pm2 logs orcfax-collector
```

## Logs and Monitoring
- Logs are managed by PM2 and stored in the PM2 logs directory.

```bash
pm2 logs orcfax-collector
```

## Contributions
Community contributions are welcome! If you encounter issues or have suggestions for improvement, feel free to open an issue or submit a pull request.

## License
This repository is shared under the MIT License. Feel free to use and modify the scripts to suit your needs.
