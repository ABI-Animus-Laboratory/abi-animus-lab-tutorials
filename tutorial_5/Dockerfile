# OpenCOR 0.8.3 Tutorial Environment
# Ubuntu 24.04 base with OpenCOR and all dependencies pre-installed

FROM ubuntu:24.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Pacific/Auckland

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
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
    libxtst6 \
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

# Add OpenCOR to PATH and set library path
ENV PATH="/opt/OpenCOR/bin:/opt/OpenCOR:${PATH}"
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
RUN echo '#!/bin/bash\n\
    export LD_LIBRARY_PATH="/opt/OpenCOR/lib:${LD_LIBRARY_PATH}"\n\
    export PATH="/opt/OpenCOR/bin:/opt/OpenCOR:${PATH}"\n\
    export JUPYTER_CONFIG_DIR=/tmp/jupyter_config\n\
    mkdir -p $JUPYTER_CONFIG_DIR\n\
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

# Default command: Start Jupyter Notebook
CMD ["/opt/OpenCOR/start_jupyter.sh"]
