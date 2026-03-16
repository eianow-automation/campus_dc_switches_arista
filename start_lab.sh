#!/bin/bash
set -e

echo "[*] Starting Containerlab MLAG Lab"
sudo containerlab deploy -t lab.clab.yaml

echo "[*] Waiting for nodes to initialize..."
sleep 10

echo "[*] Lab nodes are now up. You can connect using:"
echo "    containerlab inspect -t lab"
echo "    docker exec -it clab-lab-srv01 Cli"
