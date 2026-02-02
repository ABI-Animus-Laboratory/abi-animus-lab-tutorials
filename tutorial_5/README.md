# OpenCOR 0.8.3 + ImageJ/Fiji Tutorial

A Docker-based tutorial environment for learning OpenCOR CellML modeling with ImageJ/Fiji for image analysis.

## Quick Start

### Linux

```bash
# Allow X11 connections from Docker
xhost +local:docker

# Build and start the container
docker compose up --build -d

# Access Jupyter at http://localhost:8888
# ImageJ/Fiji GUI will launch automatically on your desktop
```

### Windows (with VcXsrv or X410)

1. Install an X server (VcXsrv or X410)
2. Start the X server with "Disable access control" checked
3. Run:

```powershell
docker compose up --build -d
# Access Jupyter at http://localhost:8888
```

### macOS (with XQuartz)

1. Install XQuartz: `brew install --cask xquartz`
2. Open XQuartz > Preferences > Security > Enable "Allow connections from network clients"
3. Restart XQuartz, then run:

```bash
xhost + 127.0.0.1
docker compose up --build -d
# Access Jupyter at http://localhost:8888
```

## Accessing the Tutorial

Once the container is running:
- **Jupyter Notebook**: http://localhost:8888
- **ImageJ/Fiji**: GUI launches automatically (requires X11 setup)

Open `opencor_tutorial.ipynb` to begin the tutorial.

## Container Management

```bash
docker compose logs -f    # View logs
docker compose down       # Stop container
docker compose up --build # Rebuild after changes
```

### Restart Fiji (if accidentally closed)

```bash
docker exec -it opencor-tutorial /opt/fiji/fiji-linux-x64 &
```

## What's Included

- **OpenCOR 0.8.3** - Pre-installed at `/opt/OpenCOR`
- **ImageJ/Fiji (Latest)** - Pre-installed at `/opt/fiji`
- **Java 21 Runtime** - Bundled with Fiji
- **Python 3.12** - OpenCOR's bundled Python
- **Pre-installed Libraries:**
  - numpy, pandas, scipy, matplotlib, seaborn
  - libcellml 0.6.3
  - sympy, statsmodels
  - SALib, emcee, corner
  - mpi4py, schwimmbad
  - rdflib, tqdm

## Troubleshooting

### ImageJ GUI not displaying

The container auto-detects your display configuration. If ImageJ doesn't appear:

**Linux:**
```bash
xhost +local:docker
```

**Windows:**
- Ensure VcXsrv/X410 is running with "Disable access control" enabled
- Check firewall allows connections on port 6000

**macOS:**
- Ensure XQuartz is properly configured and restarted
- Run `xhost + 127.0.0.1` before starting the container

### Permission issues on Linux
```bash
sudo usermod -aG docker $USER
# Log out and back in
```
