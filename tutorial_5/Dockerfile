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
    && rm -rf /var/lib/apt/lists/*

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
