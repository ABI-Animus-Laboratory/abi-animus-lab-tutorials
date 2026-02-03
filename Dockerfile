# OpenCOR 0.8.3 + ImageJ/Fiji 2.16.1 Tutorial Environment
# Ubuntu 24.04 base with OpenCOR, ImageJ/Fiji and all dependencies pre-installed

FROM ubuntu:24.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Pacific/Auckland

# Set DISPLAY for X11 forwarding (required for ImageJ GUI)
ENV DISPLAY=:0

# Install system dependencies (OpenCOR + ImageJ/Fiji requirements)
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core utilities
    wget \
    curl \
    ca-certificates \
    unzip \
    software-properties-common \
    # Java runtime for ImageJ/Fiji
    openjdk-8-jre \
    # X11 libraries for ImageJ GUI
    libxrender1 \
    libxtst6 \
    libxi6 \
    libgtk2.0-0 \
    # OpenCOR dependencies
    libgl1 \
    libxkbcommon-x11-0 \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libdbus-1-3 \
    libpulse0 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libasound2t64 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libfontconfig1 \
    fonts-liberation \
    xdg-utils \
    # VItA build dependencies
    git \
    g++ \
    make \
    cmake \
    libgl1-mesa-dev \
    freeglut3-dev \
    libglew-dev \
    libglm-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.9.18 as an additional kernel
RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.9 python3.9-distutils python3.9-dev \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.9 get-pip.py \
    && python3.9 -m pip install ipykernel \
    && python3.9 -m ipykernel install --name python3.9 --display-name "Python 3.9" \
    && rm get-pip.py

# Install Miniconda and configure the environment
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    && rm /tmp/miniconda.sh

# Accept Conda Terms of Service (required for defaults channel)
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r || true

# Create the conda environment from file
COPY tutorial_Alireza/environment.yml /tmp/environment.yml
# Install mamba for faster and better dependency resolution
# Remove expat/libexpat version pins which conflict with vtk (vtk needs libexpat <2.6.0 but env specifies 2.6.1)
# The solver will automatically install compatible expat versions as transitive dependencies
RUN conda install -n base -c conda-forge mamba -y \
    && sed -i '/^  - expat=/d' /tmp/environment.yml \
    && sed -i '/^  - libexpat=/d' /tmp/environment.yml \
    && mamba env create -f /tmp/environment.yml \
    && conda clean -ya

# Register the conda environment as a Jupyter kernel
# We install ipykernel explicitly in the environment to ensure it's available
RUN /opt/conda/envs/femSolver/bin/pip install ipykernel \
    && /opt/conda/envs/femSolver/bin/python -m ipykernel install --name femSolver --display-name "Python (femSolver)"

# Verify key packages are installed in the femSolver environment
RUN /opt/conda/envs/femSolver/bin/python -c "import numpy; print(f'numpy: {numpy.__version__}'); import scipy; print(f'scipy: {scipy.__version__}'); import pyvista; print(f'pyvista: {pyvista.__version__}'); import vtk; print(f'vtk: {vtk.vtkVersion.GetVTKVersion()}'); print('All key packages verified!')"

# Build VItA library (Virtual ITerative Angiogenesis) with VTK 8.1
# This generates synthetic vasculature networks as .vtp files
# Note: VTK 8.1 is built from source (~30+ min on first build)
WORKDIR /opt/vita
RUN git clone --depth 1 https://github.com/GonzaloMaso/VItA.git vita_source \
    && mkdir vita_build \
    # Fix bug in VItA's dependencies.cmake: -j32 is a make flag, not cmake
    && sed -i 's/-j32//g' vita_source/dependencies.cmake \
    && cd vita_build \
    && cmake ../vita_source \
    -DCMAKE_INSTALL_PREFIX=/opt/vita \
    -DDOWNLOAD_DEPENDENCIES=ON \
    -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc) \
    && make install

# Set VItA environment variables
ENV VITA_PATH=/opt/vita
ENV LD_LIBRARY_PATH="${VITA_PATH}/vita_build/lib:${VITA_PATH}/lib:${LD_LIBRARY_PATH}"

# Create VItA example compilation helper script
RUN mkdir -p /opt/vita/bin && echo '#!/bin/bash\n\
    # VItA Example Compiler and Runner\n\
    # Usage: run_vita_example <example.cpp> [output_dir]\n\
    \n\
    EXAMPLE=$1\n\
    OUTPUT_DIR=${2:-$(pwd)}\n\
    \n\
    if [ -z "$EXAMPLE" ]; then\n\
    echo "Usage: run_vita_example <example.cpp> [output_dir]"\n\
    exit 1\n\
    fi\n\
    \n\
    g++ "$EXAMPLE" -Wall -std=c++11 -O3 \\\n\
    -I/opt/vita/vita_build/include/vtk-8.1 \\\n\
    -I/opt/vita/include/vita_source \\\n\
    -L/opt/vita/vita_build/lib \\\n\
    -L/opt/vita/lib \\\n\
    -o /tmp/vita_example \\\n\
    -lVItA \\\n\
    -lvtkCommonCore-8.1 \\\n\
    -lvtkCommonDataModel-8.1 \\\n\
    -lvtkCommonExecutionModel-8.1 \\\n\
    -lvtkFiltersModeling-8.1 \\\n\
    -lvtkIOCore-8.1 \\\n\
    -lvtkIOLegacy-8.1 \\\n\
    -lvtkIOXML-8.1 \\\n\
    -lvtkIOGeometry-8.1 \\\n\
    -lvtkInfovisCore-8.1 \\\n\
    -lvtkFiltersGeneral-8.1 \\\n\
    -lvtkFiltersCore-8.1 \\\n\
    -lvtkCommonTransforms-8.1 \\\n\
    -lvtkIOXMLParser-8.1\n\
    \n\
    cd "$OUTPUT_DIR"\n\
    /tmp/vita_example\n\
    ' > /opt/vita/bin/run_vita_example && chmod +x /opt/vita/bin/run_vita_example

# Add VItA bin to PATH
ENV PATH="/opt/vita/bin:${PATH}"

WORKDIR /tutorials/tutorial_Alireza
RUN git clone -b min_lab_use https://github.com/Cameron-Apeldoorn/MicrovascularModelling.git

WORKDIR /tutorials/tutorial_5
RUN git clone -b devel_interactive_tutorial https://github.com/FinbarArgus/circulatory_autogen.git

# Download and install OpenCOR 0.8.3
WORKDIR /tmp
RUN wget -q https://github.com/opencor/opencor/releases/download/v0.8.3/OpenCOR-0-8-3-Linux.tar.gz \
    && mkdir -p /opt/OpenCOR \
    && tar -xzf OpenCOR-0-8-3-Linux.tar.gz -C /opt/OpenCOR --strip-components=1 \
    && rm OpenCOR-0-8-3-Linux.tar.gz

# Download and install ImageJ/Fiji (latest stable with bundled JDK)
RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-latest-linux64-jdk.zip \
    && unzip -q fiji-latest-linux64-jdk.zip -d /opt \
    && mv /opt/Fiji /opt/fiji \
    && chmod +x /opt/fiji/fiji-linux-x64 \
    && rm fiji-latest-linux64-jdk.zip

# Add OpenCOR and Fiji to PATH and set library path
ENV PATH="/opt/OpenCOR/bin:/opt/OpenCOR:/opt/fiji:${PATH}"
ENV LD_LIBRARY_PATH="/opt/OpenCOR/lib:${LD_LIBRARY_PATH}"

# Install Python dependencies using OpenCOR's pip
COPY requirements.txt /tmp/requirements.txt
RUN /opt/OpenCOR/pip install --no-cache-dir -r /tmp/requirements.txt

# Fix the OpenCOR kernel.json to use full path
RUN sed -i 's|"OpenCOR"|"/opt/OpenCOR/bin/OpenCOR"|g' /opt/OpenCOR/Python/share/jupyter/kernels/OpenCOR/kernel.json

# Create working directory for notebooks
WORKDIR /tutorials
COPY . /tutorials/

# Expose Jupyter port
EXPOSE 8888

# Create startup script using OpenCOR's jupyter wrapper with proper libs
# Also launches ImageJ/Fiji in background for GUI access
# Auto-detects DISPLAY for cross-platform support (Linux, Windows, Mac)
RUN echo '#!/bin/bash\n\
    export LD_LIBRARY_PATH="/opt/OpenCOR/lib:${LD_LIBRARY_PATH}"\n\
    export PATH="/opt/OpenCOR/bin:/opt/OpenCOR:/opt/fiji:${PATH}"\n\
    export JUPYTER_CONFIG_DIR=/tmp/jupyter_config\n\
    mkdir -p $JUPYTER_CONFIG_DIR\n\
    \n\
    # Auto-detect DISPLAY for cross-platform X11 support\n\
    if [ -z "$DISPLAY" ]; then\n\
    # No DISPLAY set, try to detect the best option\n\
    if [ -e /tmp/.X11-unix/X0 ]; then\n\
    # Linux with X11 socket available\n\
    export DISPLAY=:0\n\
    elif getent hosts host.docker.internal > /dev/null 2>&1; then\n\
    # Windows/Mac Docker Desktop\n\
    export DISPLAY=host.docker.internal:0\n\
    fi\n\
    fi\n\
    \n\
    # Launch ImageJ/Fiji in background if DISPLAY is available\n\
    if [ -n "$DISPLAY" ]; then\n\
    echo "Starting ImageJ/Fiji with DISPLAY=$DISPLAY"\n\
    /opt/fiji/fiji-linux-x64 &\n\
    else\n\
    echo "No DISPLAY available - ImageJ GUI disabled"\n\
    echo "To enable GUI, set up X11 forwarding (see README.md)"\n\
    fi\n\
    \n\
    cd /tutorials\n\
    /opt/OpenCOR/Python/bin/jupyter notebook \\\n\
    --ip=0.0.0.0 \\\n\
    --port=8888 \\\n\
    --no-browser \\\n\
    --allow-root \\\n\
    --ServerApp.token="" \\\n\
    --ServerApp.password="" \\\n\
    --notebook-dir=/tutorials' \
    > /opt/OpenCOR/start_jupyter.sh \
    && chmod +x /opt/OpenCOR/start_jupyter.sh

# Default command: Start Jupyter Notebook and ImageJ
CMD ["/opt/OpenCOR/start_jupyter.sh"]