# Release Notes for v0.3.0

## Release Instructions

After this PR is merged to the main branch, create the v0.3.0 release using one of the following methods:

### Method 1: Using GitHub CLI (gh)
```bash
git checkout main
git pull origin main
git tag v0.3.0
git push origin v0.3.0
gh release create v0.3.0 --title "v0.3.0" --notes "Release v0.3.0"
```

### Method 2: Using GitHub Web Interface
1. Go to the repository on GitHub
2. Click on "Releases" in the right sidebar
3. Click "Draft a new release"
4. In "Choose a tag", type `v0.3.0` and select "Create new tag: v0.3.0 on publish"
5. Set the release title to `v0.3.0`
6. Add release notes (can reference CHANGELOG.md)
7. Click "Publish release"

### Method 3: Using Git Command Line Only
```bash
git checkout main
git pull origin main
git tag -a v0.3.0 -m "Release v0.3.0"
git push origin v0.3.0
```
Note: This will create the tag and trigger the GitHub Actions workflow. You can then create the release from the tag in the GitHub web interface.

## What Happens After Tag Creation

Once the `v0.3.0` tag is pushed:
1. The GitHub Actions workflow (`.github/workflows/deploy.yml`) will automatically trigger
2. A Docker image will be built and pushed to GitHub Container Registry (ghcr.io)
3. The image will be tagged with:
   - `v0.3.0` (exact version)
   - `0.3` (major.minor)
   - `latest`

## Changes in This Release

See CHANGELOG.md for a complete list of changes.
