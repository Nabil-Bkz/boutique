# Quick Start: CI/CD Setup

## ✅ What's Been Set Up

1. **CI Workflows** (`.github/workflows/`)
   - `backend-ci.yml` - Runs tests, linting, formatting checks for backend
   - `frontend-ci.yml` - Runs tests and linting for frontend
   - `deploy.yml` - Deploys to your server automatically

2. **Docker Configuration**
   - `docker-compose.yml` - Production deployment configuration
   - Updated Dockerfiles with environment variable support

3. **Deployment Scripts**
   - `deploy.sh` - Manual deployment script

## 🚀 How to Test CI/CD

### Step 1: Configure GitHub Secrets

Go to: https://github.com/Nabil-Bkz/boutique/settings/secrets/actions

Add these secrets:

1. **SSH_PRIVATE_KEY**
   ```bash
   # Generate SSH key if needed
   ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_key
   
   # Copy private key content
   cat ~/.ssh/github_actions_key
   # Copy everything including -----BEGIN and -----END lines
   
   # Add public key to server
   ssh-copy-id -i ~/.ssh/github_actions_key.pub admin@YOUR_SERVER_IP
   ```

2. **SERVER_HOST** - Your server IP (e.g., `35.180.255.192`)
3. **SERVER_USER** - SSH user (usually `admin`)
4. **DEPLOY_PATH** - Deployment path (default: `/home/admin/boutique`)

### Step 2: Test CI (Continuous Integration)

1. Make a small change to trigger CI:
   ```bash
   git checkout feature/frontend-ci
   echo "# Test" >> README.md
   git add README.md
   git commit -m "Test CI"
   git push origin feature/frontend-ci
   ```

2. Create a Pull Request to `main`:
   - Go to: https://github.com/Nabil-Bkz/boutique/compare/main...feature/frontend-ci
   - Click "Create Pull Request"
   - CI workflows will run automatically

3. Check CI status:
   - Go to: https://github.com/Nabil-Bkz/boutique/actions
   - You should see "Backend CI" and "Frontend CI" running

### Step 3: Test CD (Continuous Deployment)

#### Option A: Automatic Deployment (Push to main)

1. Merge your PR to main:
   ```bash
   git checkout main
   git merge feature/frontend-ci
   git push origin main
   ```

2. Check deployment:
   - Go to: https://github.com/Nabil-Bkz/boutique/actions
   - Look for "Deploy to Server" workflow
   - It will SSH to your server and deploy with Docker Compose

#### Option B: Manual Deployment via GitHub Actions

1. Go to: https://github.com/Nabil-Bkz/boutique/actions
2. Click "Deploy to Server" workflow
3. Click "Run workflow"
4. Enter:
   - Server IP: `35.180.255.192` (or your server)
   - SSH User: `admin`
5. Click "Run workflow"

#### Option C: Manual Deployment via Script

```bash
export SERVER_HOST=35.180.255.192
export SERVER_USER=admin
export DEPLOY_PATH=/home/admin/boutique
./deploy.sh
```

### Step 4: Verify Deployment

1. **Check GitHub Actions logs**:
   - Go to: https://github.com/Nabil-Bkz/boutique/actions
   - Click on the latest "Deploy to Server" run
   - Check for "✅ Deployment successful!"

2. **Check server**:
   ```bash
   ssh admin@YOUR_SERVER_IP
   cd /home/admin/boutique
   docker ps
   docker compose logs
   ```

3. **Access application**:
   - Frontend: http://YOUR_SERVER_IP/
   - Backend API: http://YOUR_SERVER_IP:8000/api/products/
   - Admin: http://YOUR_SERVER_IP:8000/admin/

## 🔧 Troubleshooting

### CI Not Running

- Check workflow files are in `.github/workflows/` ✅
- Check you're pushing to correct branch (main or PR)
- Check GitHub Actions tab for errors

### Deployment Fails

1. **SSH Connection Issues**:
   ```bash
   # Test SSH manually
   ssh admin@YOUR_SERVER_IP
   
   # Check SSH key is added
   ssh-add -l
   ```

2. **Docker Not Installed**:
   ```bash
   ssh admin@YOUR_SERVER_IP
   docker --version
   # If not installed, see DEPLOYMENT.md
   ```

3. **Port Already in Use**:
   ```bash
   ssh admin@YOUR_SERVER_IP
   docker compose down
   # Then redeploy
   ```

### Frontend Can't Connect to Backend

- Check `VITE_API_URL` is set correctly in deployment
- Check backend is running: `docker ps`
- Check backend logs: `docker compose logs backend`
- Verify API is accessible: `curl http://YOUR_SERVER_IP:8000/api/products/`

## 📝 Next Steps

1. ✅ Set up GitHub Secrets
2. ✅ Test CI with a PR
3. ✅ Test CD by deploying to main
4. ✅ Verify application is accessible
5. ✅ Monitor deployments in GitHub Actions

For detailed information, see [DEPLOYMENT.md](./DEPLOYMENT.md)

