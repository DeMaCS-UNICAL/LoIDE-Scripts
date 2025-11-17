# LoIDE-Scripts
This repository contains a collection of shell scripts to automate the deployment, management, and teardown of all components of LoIDE.

## Deployment Scripts
The following scripts orchestrate the initialization of the LoIDE components. Each script automatically pulls the latest Docker images, mounts the required configuration files, and directs container output to designated log files. 
**Important:** These scripts contain internal variables that must be manually configured within the files prior to execution.

### DeployESE.sh
This script automates the deployment of [PythonESE](https://github.com/DeMaCS-UNICAL/PythonESE). To work correctly, the following variables *must* be configurated:

* **BASE_PATH**: The root directory path where the folder is located.
* **CONFIG_PATH_ESE**: The file path to the configuration folder.
* **EXECUTABLES_PATH_ESE**: The file path to the folder containing the executables.
* **LOGS_PATH_ESE**: The specific file path where the container logs will be written.

### DeployPWA-API.sh
This script manages the deployment of both the [LoIDE-API-Server](https://github.com/DeMaCS-UNICAL/LoIDE-API-Server) and the [LoIDE-PWA](https://github.com/DeMaCS-UNICAL/LoIDE-PWA) components. 

* **BASE_PATH**: The root directory path where both folders are located.
* **API_SERVER**: The IP address of the server where LoIDE-API-Server is running, required for the LoIDE-PWA to connect correctly.
* **CONFIG_PATH_API**: The file path to the LoIDE-API-Server configuration folder.
* **LOGS_PATH_API**: The specific file path where the LoIDE-API-Server logs will be written.
* **CONFIG_SERVER_PATH_PWA**: The file path to the LoIDE-PWA server configuration folder.
* **CONFIG_SSL_PATH_PWA**: The file path to the SSL certificates folder for the LoIDE-PWA.
* **LOGS_PATH_PWA**: The specific file path where the LoIDE-PWA logs will be written.


## Maintenance Scripts

These scripts facilitate the management of the container lifecycle. `StopESE.sh` and `StopPWA-API.sh` provide targeted commands to halt the PythonESE, LoIDE-PWA, and LoIDE-API-Server containers respectively, while `RemoveAllContainers.sh` first stops the LoIDE-API-Server and LoIDE-PWA services and then removes the Docker containers from the system.

## Installation Utilities

The `DockerInstallationScript.sh` is based on the official [Docker installation guide](https://docs.docker.com/engine/install/debian) for Debian and Ubuntu systems. It automates the setup of the Docker environment, including adding the official GPG key, setting up the repository, and installing the Docker engine and associated plugins.