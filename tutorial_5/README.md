# OpenCOR 0.8.3 Jupyter Tutorial

A Docker-based tutorial environment for learning OpenCOR and CellML modeling.

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Build and start the container
docker-compose up --build

# Access Jupyter at http://localhost:8888
```

### Option 2: Using Docker directly

```bash
# Build the image
docker build -t opencor-tutorial .

# Run the container
docker run -p 8888:8888 -v $(pwd):/tutorials opencor-tutorial
```

### Option 3: Run in background

```bash
# Start in detached mode
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

## Accessing the Tutorial

Once the container is running, open your browser and navigate to:

**http://localhost:8888**

Then open `opencor_tutorial.ipynb` to begin the tutorial.

## What's Included

- **OpenCOR 0.8.3** - Pre-installed at `/opt/OpenCOR`
- **Python 3.12** - OpenCOR's bundled Python
- **Pre-installed Libraries:**
  - numpy, pandas, scipy, matplotlib, seaborn
  - libcellml 0.6.3
  - sympy, statsmodels
  - SALib, emcee, corner
  - mpi4py, schwimmbad
  - rdflib, tqdm

## Technical Notes

- The container uses OpenCOR's bundled Python (`/opt/OpenCOR/run_python`)
- Jupyter is launched via `/opt/OpenCOR/jupyternotebook`
- All notebooks are saved to the mounted volume for persistence

## Troubleshooting

### Port already in use
```bash
# Use a different port
docker run -p 9999:8888 -v $(pwd):/tutorials opencor-tutorial
# Then access at http://localhost:9999
```

### Permission issues on Linux
```bash
# Add your user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

### Rebuild after changes
```bash
docker-compose down
docker-compose up --build
```
