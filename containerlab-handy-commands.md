# Containerlab Handy Commands Reference

## Installation, Upgrading & Version

| Command | Description |
|---|---|
| `bash -c "$(curl -sL https://get.containerlab.dev)"` | **Install** containerlab (auto-detects OS and architecture) |
| `curl -sL https://containerlab.dev/setup \| sudo -E bash -s "all"` | Install containerlab **and** all dependencies (Docker, etc.) in one shot |
| `sudo containerlab version upgrade` | **Upgrade** containerlab to the latest release |
| `sudo clab version upgrade --version 0.55.0` | Upgrade (or downgrade) to a **specific** version |
| `clab version` | Check the currently installed containerlab version |
| `newgrp docker` | Enable sudo-less Docker access after a fresh install (or log out/back in) |

## Inspecting & Viewing Topologies

| Command | Description |
|---|---|
| `clab inspect --all` | List **all** deployed labs across the entire host |
| `clab inspect -t <file.clab.yml>` | Show nodes/status for a specific topology file |
| `clab inspect --name <lab-name>` | Inspect a lab by its name |
| `clab inspect --all --format json` | List all labs in JSON format (also supports `csv`) |
| `clab graph -t <file.clab.yml>` | Launch an interactive topology graph in your browser at `http://localhost:50080` |
| `clab graph -t <file.clab.yml> --srv :8080` | Serve the graph on a custom port |
| `clab graph -t <file.clab.yml> --drawio` | Export topology as a draw.io diagram file |
| `clab graph -t <file.clab.yml> --mermaid` | Export topology in Mermaid format (renders in GitHub/GitLab markdown) |
| `clab graph -t <file.clab.yml> --dot` | Export topology in Graphviz DOT format |

## Deploying (Starting) a Topology

| Command | Description |
|---|---|
| `clab deploy -t <file.clab.yml>` | Deploy a lab from a topology file |
| `clab deploy` | Auto-detect and deploy from any `*.clab.yml` file in the current directory |
| `clab deploy -t <file.clab.yml> --max-workers 2` | Limit concurrent container creation (useful on resource-constrained hosts) |
| `clab deploy -t <file.clab.yml> --node-filter node1,node2` | Deploy only specific nodes from the topology |
| `clab deploy -t https://example.com/topo.clab.yml` | Deploy directly from a remote URL |

## Destroying (Stopping) a Topology

| Command | Description |
|---|---|
| `clab destroy -t <file.clab.yml>` | Destroy a specific lab (forceful stop by default) |
| `clab destroy -t <file.clab.yml> --graceful` | **Safely** shut down containers before removing them |
| `clab destroy -t <file.clab.yml> --cleanup` | Destroy and also remove the lab directory and all generated files |
| `clab destroy --all` | Destroy every running lab on the host (prompts for confirmation) |
| `clab destroy --all --yes` | Destroy all labs without the confirmation prompt |
| `clab destroy -t <file.clab.yml> --node-filter node1` | Destroy only specific nodes, leave the rest running |
| `docker rm -f <node Name from clab inspect --all>` | If all else fails, use docker to remove the node(s) |

## Restarting / Redeploying a Topology

| Command | Description |
|---|---|
| `clab redeploy -t <file.clab.yml>` | Destroy + clean redeploy in one step (removes lab dir first) |
| `clab deploy -t <file.clab.yml> -c` | Same as redeploy — the `-c` (reconfigure) flag destroys first, then deploys fresh |

## Interacting with Running Nodes

| Command | Description |
|---|---|
| `docker exec -it <container-name> bash` | Open an interactive shell on a running node |
| `docker exec -it <container-name> sr_cli` | Connect to Nokia SR Linux CLI |
| `ssh admin@clab-<lab>-<node>` | SSH into a node using its containerlab-assigned hostname |
| `clab exec --name <lab-name> --cmd "show version"` | Run a command across lab nodes |

## Saving Configs

| Command | Description |
|---|---|
| `clab save -t <file.clab.yml>` | Save the running configuration of all nodes in the lab |

## Generating Topologies

| Command | Description |
|---|---|
| `clab generate --name mylab --kind srl --nodes 6 --image ghcr.io/nokia/srlinux` | Generate a CLOS fabric topology of arbitrary scale |

## Monitoring System Resources (Ubuntu/Linux)

These are essential for making sure your host isn't running out of resources when running containerlab topologies.

| Command | Description |
|---|---|
| `docker stats` | **Live** CPU, memory, network, and disk I/O for all running containers |
| `docker stats --no-stream` | Snapshot of container resource usage (non-blocking, runs once) |
| `docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"` | Custom formatted container stats |
| `docker system df` | Show disk usage by images, containers, volumes, and build cache |
| `docker system df -v` | Verbose disk usage breakdown per image and container |
| `docker system prune` | Remove unused containers, networks, images, and build cache to free space |
| `df -h` | Check available disk space on all mounted filesystems |
| `free -h` | Check total/used/available RAM and swap |
| `htop` | Interactive process viewer — great for spotting CPU/memory hogs |
| `nproc` | Show available CPU cores (helpful for sizing `--max-workers`) |
| `du -sh /var/lib/docker` | Check total disk space consumed by Docker |
| `docker image ls` | List all pulled container images and their sizes |
| `docker image prune -a` | Remove all unused images to reclaim disk space |
| `docker volume prune` | Remove unused volumes to reclaim disk space |

## Quick Tips

- **Always use `--graceful`** when destroying labs to give nodes time to shut down cleanly and avoid corrupted configs.
- **Use `clab save` before `clab destroy`** if you want to preserve running configurations.
- **Run `docker stats`** in a separate terminal while deploying large topologies to watch resource consumption in real time.
- **Set `--max-workers`** to a low number (e.g., 2–4) on machines with limited RAM to avoid memory spikes during deployment.
- **Auto-detect works** — if your current directory has a `*.clab.yml` file, you can just run `clab deploy` without `-t`.
- **Check disk regularly** with `docker system df` — container images for network OSes can be several GB each.
