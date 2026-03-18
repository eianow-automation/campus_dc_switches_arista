<img src="images/EIA Logo FINAL small_Round.png"      alt="EIA Logo FINAL small_Round"      style="zoom:25%; float:right; margin-left:8px;" />

# EIA Container Lab Quick Start - Installation

Containerlab is a lightweight, open-source CLI tool for rapidly deploying network labs using Docker (or Podman). 

It defines topologies in simple YAML files, enabling quick spin-up of single or multi-vendor environments for testing automation and features.  Because the labs are in YAML text files, they can easily be shared and put under revision control so a team can work off the same topology.

## Key Differences from other Virtual Lab Environments 

Unlike VM-heavy platforms like CML (Cisco-focused, resource-intensive simulations) or EVE-NG/GNS3 (GUI-driven, broader VM support but slower), Containerlab emphasizes container-native NOS for extreme efficiency. Lab topologies boot in seconds, use far less RAM/CPU, and integrate natively with Git, Ansible, and CI/CD pipelines.



> [!TIP]
>
> Having some basic Linux training is helpful for this and for automation in general.  See the [Handy Linux Commands](#handy-linux-commands) section at the bottom of this document.

---

[TOC]

---

## Installing
Clab works best in Linux. 

You can get it working on Windows with WSL but I recommend spinning up a Linux based Virtual Machine.

[Containerlab on Windows](https://containerlab.dev/windows/)

> [!NOTE]
>
> This is specific to the Linux distribution Ubuntu/Debian

```bash
sudo apt update && sudo apt upgrade -y
```

2. Install Required Packages

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

```bash
sudo apt install -y iproute2 iputils-ping
```

#### Add Docker's Official GPG Key and Repository

Add Docker’s GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Uninstall all conflicting packages:

```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

Add the Docker repository:

```console
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt-get update
```

Install Docker Packages

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```console
 sudo systemctl status docker
```

Some systems may have this behavior disabled and will require a manual start:

```console
$ sudo systemctl start docker
```

You may need to refresh your shell

```bash
source ~/.bashrc
```



Verify that the installation is successful by running the `hello-world` image:

```console
$ sudo docker run hello-world
```



Expected output

```bash
claudia@vps-331cdbb4:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
17eec7bbc9d7: Pull complete 
Digest: sha256:54e66cc1dd1fcb1c3c58bd8017914dbed8701e2d8c74d9262e26bd9cc1642d31
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

claudia@vps-331cdbb4:~$ 

```



### [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user

### Command line Editor

- vi

Learn & Practice!
https://vimschool.netlify.app/introduction/vimtutor/

## Installing Containerlab

[Quick Setup](https://containerlab.dev/install)

The easiest way to get started with containerlab is to use the [quick setup script](https://github.com/srl-labs/containerlab/blob/main/utils/quick-setup.sh) that installs all of the following components in one go (or allows to install them separately):

- docker (docker-ce), docker compose
- Containerlab (using the package repository)
- [`gh`](https://cli.github.com/) CLI tool

The script has been tested on the following OSes:

- Ubuntu 20.04, 22.04, 23.10, 24.04

To install all components at once, run the following command on any of the supported OSes:

```console
curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"
```



https://containerlab.dev/quickstart/



### Loading docker images

Download the latest or required cEOS image from arista.com (You will need a free Arista account using a buisness login email)

Get the image (SCP/SFTP) to your Ubuntu server.

```bash
# rename the tag as you like
docker import cEOS64-lab-4.28.xF.tar.xz ceos:4.28.xF
docker images | egrep "REPOSITORY|ceos"

```

I recommend always setting the "latest" tag.

```bash
docker import cEOS64-lab-4.28.xF.tar.xz ceos:latest
```




# Handy Linux Commads

| Command      | Description                                                  | Common Usage                                                 | Category                   |
| :----------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :------------------------- |
| `ls`         | Lists files and directories in the current directory.        | `ls -l` – List in long format with details; `ls -al` – List all files including hidden ones in long format | File management            |
| `cd`         | Changes the current working directory to the specified path. | `cd /etc` – Move to the `/etc` directory                     | File management            |
| `mkdir`      | Creates a new directory with the given name.                 | `mkdir projects` – Create a directory named *projects*       | File management            |
| `pwd`        | Prints the current working directory path.                   | `pwd` – Output current path                                  | File management            |
| `cp`         | Copies files or directories.                                 | `cp file1.txt backup/file1.txt` – Copy *file1.txt* to *backup/* | File management            |
| `mv`         | Moves or renames files and directories.                      | `mv oldname.txt newname.txt` – Rename a file                 | File management            |
| `rm`         | Removes (deletes) files or directories. Use with caution.    | `rm -r old_project` – Delete *old_project* directory and its contents | File management            |
| `sudo`       | Executes a command with elevated (superuser) privileges. Requires appropriate permissions. | `sudo apt update` – Run package update as administrator      | System administration      |
| `curl`       | Transfers data to or from a server using various protocols (HTTP, HTTPS, FTP, etc.). Requires `curl` package to be installed. | `curl -O https://example.com/file.zip` – Download a file     | Networking / Data transfer |
| `ip address` | Displays or manages IP addresses and network interfaces. Part of the `iproute2` package, which must be installed. | `ip address show` – Display network interface details        | Networking                 |
| `df`         | Shows disk space usage for mounted filesystems in human-readable form (GB/MB). | `df -h` – View free and used space on all drives             | System monitoring          |
| `du`         | Shows disk usage per directory in human-readable units (GB/MB). | `du -h --max-depth=1 /home` – Show space by directory in `/home` | System monitoring          |
| `cat`        | Displays the contents of a file on the terminal.             | `cat file.txt` – Print the contents of *file.txt*            | File viewing               |
| `less`       | Views file contents one screen at a time with navigation commands. | `less /var/log/syslog` – Page through system logs            | File viewing               |
| `vi`         | Opens the *vi* text editor for viewing or editing files. Installed by default on most Unix systems. | `vi config.txt` – Open *config.txt* in *vi* editor           | File editing               |
| `top`        | Displays real-time information about running processes and resource usage. | `top` – Monitor CPU and memory usage interactively           | System information         |
| `uname`      | Shows system information such as kernel version, hostname, and architecture. | `uname -a` – Display all available system info               | System information         |
| `who`        | Lists users currently logged into the system.                | `who` – See active login sessions                            | System information         |
