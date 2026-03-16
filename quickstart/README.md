# Quickstart

This folder contains `srl-quickstart.yml`, which uses a freely downloadable image to test your Docker and Containerlab installation.

**Purpose:** These instructions guide you through setting up and running a simple Containerlab topology using a Nokia SR Linux router. This will help you verify that your Docker and Containerlab installation is working correctly by creating a test environment, deploying the topology, and accessing the router console. All topologies will be organized under a `clab_topo` directory for better organization.

**Quick Setup (One-liner):** To quickly set up the directory structure and download the file in one command, run:

```bash
mkdir -p clab_topo/srl-quickstart && cd clab_topo/srl-quickstart && curl -O https://raw.githubusercontent.com/eianow-automation/campus_dc_switches_arista/main/quickstart/srl-quickstart.yml
```

Then proceed to step 4 below.

## Instructions

1. Create the directory structure using `mkdir -p`:
   ```bash
   mkdir -p clab_topo/srl-quickstart
   ```
   (The `-p` flag creates parent directories as needed and doesn't error if they already exist.)

2. Change into the `srl-quickstart` directory:
   ```bash
   cd clab_topo/srl-quickstart
   ```

3. Download the `srl-quickstart.yml` file (ensure it's placed in the `srl-quickstart` directory):
   - Via browser: [GitHub](https://github.com/eianow-automation/campus_dc_switches_arista/blob/main/quickstart/srl-quickstart.yml) (download raw file and save it in the `srl-quickstart` directory)
   - Via CLI:
     ```bash
     curl -O https://raw.githubusercontent.com/eianow-automation/campus_dc_switches_arista/main/quickstart/srl-quickstart.yml
     ```

4. Start the topology:
   ```bash
   clab deploy -t srl-quickstart.yml
   ```

5. Log into srl01:
   - Using Containerlab (recommended):
     ```bash
     clab exec clab-srl-quickstart-srl01 sr_cli
     ```
   - Using Docker directly:
     ```bash
     docker exec -it clab-srl-quickstart-srl01 sr_cli
     ```
   - Using SSH (username: `admin`, password: `admin`):
     First, find the management IP:
     ```bash
     clab inspect -t srl-quickstart.yml
     ```
     Then SSH:
     ```bash
     ssh admin@<management_ip>
     ```