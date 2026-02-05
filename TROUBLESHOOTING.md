# Troubleshooting CI/CD Deployment

## Common Deployment Failures

### 1. ❌ "SSH_PRIVATE_KEY secret is not set"

**Error:** The deployment workflow fails immediately with a secret error.

**Solution:**
1. Go to: https://github.com/Nabil-Bkz/boutique/settings/secrets/actions
2. Click "New repository secret"
3. Name: `SSH_PRIVATE_KEY`
4. Value: Your SSH private key content (starts with `-----BEGIN OPENSSH PRIVATE KEY-----`)
5. Click "Add secret"

**Generate SSH key if needed:**
```bash
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_key -N ""
cat ~/.ssh/github_actions_key  # Copy this to GitHub secret
ssh-copy-id -i ~/.ssh/github_actions_key.pub admin@YOUR_SERVER_IP
```

### 2. ❌ "SERVER_HOST secret is not set"

**Error:** Deployment can't find server IP address.

**Solution:**
1. Go to: https://github.com/Nabil-Bkz/boutique/settings/secrets/actions
2. Click "New repository secret"
3. Name: `SERVER_HOST`
4. Value: Your server IP (e.g., `35.180.255.192`)
5. Click "Add secret"

### 3. ❌ "SERVER_USER secret is not set"

**Error:** Deployment can't determine SSH username.

**Solution:**
1. Go to: https://github.com/Nabil-Bkz/boutique/settings/secrets/actions
2. Click "New repository secret"
3. Name: `SERVER_USER`
4. Value: `admin` (or your SSH username)
5. Click "Add secret"

### 4. ❌ SSH Connection Failed

**Error:** `Permission denied (publickey)` or connection timeout.

**Possible causes:**
- SSH key not added to server
- Wrong server IP
- Firewall blocking SSH

**Solution:**
```bash
# Test SSH connection manually
ssh admin@YOUR_SERVER_IP

# If it fails, add your public key to server
ssh-copy-id -i ~/.ssh/github_actions_key.pub admin@YOUR_SERVER_IP

# Verify key is added
ssh admin@YOUR_SERVER_IP "cat ~/.ssh/authorized_keys"
```

### 5. ❌ Docker Not Installed on Server

**Error:** `❌ Docker is not installed on the server`

**Solution:**
SSH into your server and install Docker:
```bash
ssh admin@YOUR_SERVER_IP

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose plugin
sudo apt install docker-compose-plugin -y

# Verify installation
docker --version
docker compose version

# Add user to docker group (optional)
sudo usermod -aG docker $USER
# Log out and back in for group change to take effect
```

### 6. ❌ Port Already in Use

**Error:** `Bind for 0.0.0.0:8000 failed: port is already allocated`

**Solution:**
```bash
ssh admin@YOUR_SERVER_IP
cd /home/admin/boutique

# Stop existing containers
docker compose down

# Or stop specific container
docker stop boutique-backend boutique-frontend

# Check what's using the port
sudo lsof -i :8000
sudo lsof -i :80
```

### 7. ❌ rsync Failed

**Error:** `rsync: connection unexpectedly closed`

**Possible causes:**
- SSH connection issue
- Disk space full on server
- Permission denied

**Solution:**
```bash
# Test SSH connection
ssh admin@YOUR_SERVER_IP "echo 'Connection OK'"

# Check disk space on server
ssh admin@YOUR_SERVER_IP "df -h"

# Check permissions
ssh admin@YOUR_SERVER_IP "ls -la /home/admin/"
```

### 8. ❌ Docker Build Failed

**Error:** Build errors during `docker compose up -d --build`

**Common causes:**
- Missing files in repository
- Dockerfile syntax errors
- Network issues pulling base images

**Solution:**
```bash
# Check build logs
ssh admin@YOUR_SERVER_IP
cd /home/admin/boutique
docker compose logs

# Try building manually
docker compose build --no-cache

# Check Dockerfile syntax
cat backend/Dockerfile
cat frontend/Dockerfile
```

### 9. ❌ Health Check Failed

**Error:** `⚠️ Backend health check failed` or `⚠️ Frontend health check failed`

**Possible causes:**
- Containers not started properly
- Application errors
- Firewall blocking ports

**Solution:**
```bash
# Check container status
ssh admin@YOUR_SERVER_IP
cd /home/admin/boutique
docker ps

# Check logs for errors
docker compose logs backend
docker compose logs frontend

# Test endpoints manually
curl http://localhost:8000/api/products/
curl http://localhost/

# Check if ports are accessible externally
curl http://YOUR_SERVER_IP:8000/api/products/
```

### 10. ❌ Tests Fail Before Deployment

**Error:** Backend or Frontend CI tests fail, preventing deployment.

**Solution:**
```bash
# Run tests locally to debug
cd backend
uv sync --extra dev
uv run ruff format --check .
uv run ruff check .
cd core
uv run python manage.py test

cd ../frontend
npm ci
npm run lint
npm test -- --run
```

## Quick Checklist

Before deploying, ensure:

- [ ] GitHub secrets are set:
  - [ ] `SSH_PRIVATE_KEY`
  - [ ] `SERVER_HOST`
  - [ ] `SERVER_USER`
  - [ ] `DEPLOY_PATH` (optional)

- [ ] Server is ready:
  - [ ] Docker installed
  - [ ] Docker Compose installed
  - [ ] SSH access works
  - [ ] SSH key added to server

- [ ] Code is ready:
  - [ ] All tests pass locally
  - [ ] Linting passes
  - [ ] Formatting is correct

## Getting Help

1. **Check GitHub Actions logs:**
   - Go to: https://github.com/Nabil-Bkz/boutique/actions
   - Click on failed workflow
   - Expand failed step to see error details

2. **Check server logs:**
   ```bash
   ssh admin@YOUR_SERVER_IP
   cd /home/admin/boutique
   docker compose logs
   ```

3. **Test manually:**
   - Run deployment script locally: `./deploy.sh`
   - Test SSH connection: `ssh admin@YOUR_SERVER_IP`
   - Test Docker: `docker ps`

## Common Error Messages Reference

| Error Message | Cause | Solution |
|--------------|-------|----------|
| `Secret not found` | GitHub secret missing | Add secret in repository settings |
| `Permission denied` | SSH key not authorized | Add public key to server |
| `Connection refused` | Server unreachable | Check IP, firewall, SSH service |
| `Docker not installed` | Docker missing on server | Install Docker and Docker Compose |
| `Port already allocated` | Port in use | Stop existing containers |
| `Build failed` | Dockerfile error | Check Dockerfile syntax |
| `Health check failed` | App not responding | Check container logs |

