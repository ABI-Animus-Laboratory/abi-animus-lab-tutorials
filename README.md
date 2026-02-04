# ABI Animus Lab Tutorials

Welcome to the **ABI Animus Lab Tutorials** repository! This project is a comprehensive collection of tutorials and examples designed for bioengineering simulations, supporting Python, C++, VItA, VTK, OpenCOR, and more.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Local Development](#local-development)
  - [Production](#production)
- [Tutorials Overview](#tutorials-overview)
  - [Tutorial 4: Python Environment](#tutorial-4-python-environment)
  - [Tutorial 5: OpenCOR & Jupyter](#tutorial-5-opencor--jupyter)
  - [Tutorial Alireza: Advanced C++ & VItA](#tutorial-alireza-advanced-c--vita)
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

### Installing Docker & Docker Compose

- **Windows**:
  - Install [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/).
  - Ensure WSL 2 is enabled for better performance.

- **Mac**:
  - Install [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/).
  - Supports both Intel and Apple Silicon chips.

- **Linux**:
  - Install [Docker Engine](https://docs.docker.com/engine/install/) for your distribution.
  - Install the [Docker Compose plugin](https://docs.docker.com/compose/install/linux/).
  - *Note*: Ensure your user is added to the `docker` group to run commands without `sudo`.

## Getting Started

### Local Development

To start the environment locally for development:

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-username/abi-animus-lab-tutorials.git
    cd abi-animus-lab-tutorials
    ```

2.  Build and start the container:
    ```bash
    docker compose up --build
    ```

3.  Access Jupyter Lab:
    - Open your browser and navigate to the URL displayed in the terminal (usually `http://127.0.0.1:8888/lab`).
    - The token will be provided in the improved launch logs.

### Production

To run the production version (pulling the latest image from GitHub Container Registry):

1.  Ensure you have the `docker-compose.prod.yml` file.
2.  Run the following command:
    ```bash
    docker compose -f docker-compose.prod.yml up -d
    ```

## Tutorials Overview

### Tutorial 4: Python Environment
Located in `tutorial_4/`, this tutorial focuses on establishing a robust Python environment.
- **Key Files**: `tutorial_4.ipynb`, `requirements.txt`.
- **Topics**: Setting up dependencies, verifying environment configuration.

### Tutorial 5: OpenCOR & Jupyter
Located in `tutorial_5/`, this tutorial demonstrates the integration of OpenCOR with Jupyter Lab.
- **Key Files**: `test_opencor.ipynb`, `tutorial_5.ipynb`.
- **Topics**: Launching OpenCOR from a notebook, scripting OpenCOR tasks.

### Tutorial Alireza: Advanced C++ & VItA
Located in `tutorial_Alireza/`, this section contains advanced C++ examples leveraging the VItA library for vascular generation.
- **Key Files**: `example_1/`, `tutorial_Alireza.ipynb`.
- **Topics**: Building C++ projects with CMake, linking against VItA and VTK, running MPI simulations.

## Development Notes

### Rebuilding C++ Examples

Since the C++ examples (like `tutorial_Alireza/example_1`) depend on libraries install inside the container, it is recommended to build them within the Docker environment.

1.  Open a terminal in Jupyter Lab (or attach to the running container).
2.  Navigate to the build directory:
    ```bash
    cd /home/jovyan/work/tutorial_Alireza/example_1/build
    ```
3.  Run CMake and Make:
    ```bash
    cmake ..
    make
    ```

## CI/CD

This repository is equipped with a GitHub Actions workflow that automatically builds and publishes the Docker image to the GitHub Container Registry (GHCR) when a new release tag (e.g., `v1.0.0`) is pushed.

For detailed setup and usage instructions, please refer to [GITHUB_SETUP.md](GITHUB_SETUP.md).