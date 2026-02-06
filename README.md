# ABI Animus Lab Tutorials

Welcome to the **ABI Animus Lab Tutorials** repository! This project is a comprehensive collection of tutorials and examples designed for bioengineering simulations, supporting Python, C++, VItA, VTK, OpenCOR, and more.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Tutorials Overview](#tutorials-overview)
  - [Tutorial 4: Python Environment](#tutorial-4-python-environment)
  - [Tutorial 5: OpenCOR & Jupyter](#tutorial-5-opencor--jupyter)
  - [Tutorial 6: Microvascular Modelling & VItA](#tutorial-6-microvascular-modelling--vita)
- [Development Notes](#development-notes)
- [CI/CD](#cicd)

## Features

- **Multi-Language Support**: Examples in **Python** and **C++**.
- **Containerized Environment**: Fully Dockerized setup for consistent development and deployment.
- **Scientific Libraries**: Pre-configured with **VItA**, **VTK**, **OpenCOR**, **PETSc**, **SUNDIALS**, and **nlohmann-json**.
- **Jupyter Lab Integration**: Interactive notebooks for tutorials and experimentation.
- **Automated CI/CD**: GitHub Actions workflow for building and publishing Docker images.

## Prerequisites

To run this project, you need to have **Docker** and **Docker Compose** installed on your system.
### git
Make sure you have git installed on your laptop: https://git-scm.com/
### Server to run graphical applications (X server)
- **Windows**: download VcXsrv from https://vcxsrv.com/ and follow the installation instructions.
- **Mac**: download and install XQuartz from https://www.xquartz.org/. After installation:
  - Open XQuartz.
  - Go to Settings (or Preferences) > Security.
  - Check the box: "Allow connections from network clients".
  - Restart XQuartz: You must completely quit and restart XQuartz for this change to take effect.
  - Open your Mac terminal and run:
    ```bash
    xhost +localhost
    ```
- **Linux**: to launch GUI applications (Fiji/ImageJ and ilastik) from inside the Docker container, on a terminal (on your physical machine) run:
    ```bash
    xhost +local:docker
    ```

*Note*: Ensure you run this server before running the Docker container.


### Installing Docker & Docker Compose

- **Windows**:
  - Install [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/).
  - Ensure WSL 2 is enabled for better performance.
  - *Note*: Ensure you run Docker before running the container.

- **Mac**:
  - Install [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/).
  - Supports both Intel and Apple Silicon chips.
  - *Note*: Ensure you run Docker before running the container.

- **Linux**:
  - Install [Docker Engine](https://docs.docker.com/engine/install/) for your distribution.
  - Install the [Docker Compose plugin](https://docs.docker.com/compose/install/linux/).
  - *Note*: Ensure your user is added to the `docker` group to run commands without `sudo`.
    ```bash
    sudo usermod -aG docker $USER
    newgrp docker
    ```
    To test it, run:
    ```bash
    docker run hello-world
    ```

## Getting Started

To start the environment locally for development:

1.  Clone the repository:
    ```bash
    git clone https://github.com/ABI-Animus-Laboratory/abi-animus-lab-tutorials.git
    cd abi-animus-lab-tutorials
    ```

2.  Run the following command (pull and run the latest images from GitHub Container Registry):
    - **Linux and Windows**:
    ```bash
    docker compose -f docker-compose.prod.yml up -d
    ```
    - **Mac**:
    ```bash
    docker compose -f docker-compose.prod.mac.yml up -d
    ```

3.  Access Jupyter Lab:
    - Open your browser and navigate to the URL displayed in the terminal (usually `http://127.0.0.1:8888/lab`).
    - The token will be provided in the improved launch logs.

4. To shut down the Container and the Network that were created specifically by the *.yml file:
    - **Linux and Windows**:
    ```bash
    docker compose -f docker-compose.prod.yml down
    ```
    - **Mac**:
    ```bash
    docker compose -f docker-compose.prod.mac.yml down
    ```
*Note*: Since you are not building the Docker images locally in your machine, restart from step 2 everytime you shut down the Container or your machine.

### Tutorial 6

Navigate to the folder `tutorial_6/vital_multiscale` and follow the instructions in the corresponding `README.md` file.

## Tutorials Overview

### Tutorial 4: Python Environment
Located in `tutorial_4/`, this tutorial focuses on establishing a robust Python environment.
- **Key Files**: `tutorial_4.ipynb`, `requirements.txt`.
- **Topics**: Setting up dependencies, verifying environment configuration.

### Tutorial 5: OpenCOR & Jupyter
Located in `tutorial_5/`, this tutorial demonstrates the integration of OpenCOR with Jupyter Lab.
- **Key Files**: `test_opencor.ipynb`, `tutorial_5.ipynb`.
- **Topics**: Launching OpenCOR from a notebook, scripting OpenCOR tasks.

### Tutorial 6: Microvascular Modelling & VItA
Located in `tutorial_6/`, this section contains advanced examples leveraging the VItA library for vascular generation.
- **Key Files**: `test.ipynb`, `vital_multiscale/`.
- **Topics**: Microvascular modelling, VItA integration.

## Development Notes

### Local Development

To start the environment locally for development, **build** and start the container:
```bash
docker compose up --build
```

### Rebuilding C++ Examples

If you need to rebuild C++/VItA examples, ensure you are in the correct build directory within the container.
1.  Open a terminal in Jupyter Lab (or attach to the running container).
2.  Navigate to the build directory (e.g., inside `tutorial_6/vital_multiscale` or similar if applicable, checking structure).
    *Note: Specific build paths may vary based on the tutorial's internal structure.*

## CI/CD

This repository is equipped with a GitHub Actions workflow that automatically builds and publishes the Docker image to the GitHub Container Registry (GHCR) when a new release tag (e.g., `v1.0.0`) is pushed.

For detailed setup and usage instructions, please refer to [GITHUB_SETUP.md](GITHUB_SETUP.md).
