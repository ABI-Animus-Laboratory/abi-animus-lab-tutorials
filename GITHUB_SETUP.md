# GitHub Actions & GHCR Setup Guide

This guide explains how to configure your repository to automatically build and push Docker images to the GitHub Container Registry (GHCR) and how to run them in production.

## 1. Configure Repository Settings

Before pushing, ensure your repository has the correct permissions for GitHub Actions.

1.  Go to your repository on GitHub.
2.  Navigate to **Settings** > **Actions** > **General**.
3.  Scroll down to **Workflow permissions**.
4.  Select **Read and write permissions**.
5.  Click **Save**.

## 2. Commit and Push Configuration

You need to commit the workflow file and the production compose file I created.

```bash
git add .github/workflows/deploy.yml docker-compose.prod.yml
git commit -m "Add CI/CD workflow and production compose file"
git push origin main
```

## 3. Trigger a Build

The workflow is configured to run ONLY when you push a tag starting with `v` (e.g., `v1.0.0`).

To trigger the build:

```bash
# Create a new tag
git tag v1.0.0

# Push the tag to GitHub
git push origin v1.0.0
```

1.  Go to the **Actions** tab in your repository.
2.  You should see a new workflow run named **Build and Publish Docker Image**.
3.  Wait for it to complete (green checkmark).

## 4. Verify Image in GHCR

Once the action completes:

1.  Go to your repository's main page.
2.  Look for the **Packages** section on the right sidebar (or under your Profile > Packages).
3.  You should see a package named `abi-animus-lab-tutorials`.
4.  Click on it to see the details and pull instructions.

## 5. Make the Package Public (Optional)

By default, packages might be private. If you want others to pull it without authentication:

1.  Go to the Package page.
2.  Click **Package settings** (sidebar).
3.  Scroll to **Danger Zone** > **Change visibility**.
4.  Select **Public**.

## 6. Run in Production

On your production server (or local machine for testing):

1.  Ensure you have `docker-compose.prod.yml`.
2.  Run the container:

```bash
docker compose -f docker-compose.prod.yml up -d
```

### Note on Authentication
If the package is **Private**, you must log in before pulling:

```bash
# Create a Classic Personal Access Token (PAT) with 'read:packages' scope
echo "YOUR_PAT_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```
