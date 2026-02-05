# Deployment Guide

This guide explains how to set up CI/CD to deploy the Boutique Couture application to your server.

## Prerequisites

1. **Server Access**: SSH access to your server (one of the student servers)
2. **Docker**: Docker and Docker Compose must be installed on the server
3. **GitHub Secrets**: Configure secrets in your GitHub repository

## Server Setup

### 1. Install Docker on the Server

SSH into your server and run:

```bash
# Update system
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose (if not included)
sudo apt install docker-compose-plugin

# Add your user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER
```

### 2. Verify Docker Installation

```bash
docker --version
docker compose version
```

## GitHub Secrets Configuration

Go to your GitHub repository: `https://github.com/Nabil-Bkz/boutique/settings/secrets/actions`

Add the following secrets:

### Required Secrets

1. **`SSH_PRIVATE_KEY`**: Your SSH private key for server access
   - Generate if needed: `ssh-keygen -t ed25519 -C "github-actions"`
   - Copy the private key content (starts with `-----BEGIN OPENSSH PRIVATE KEY-----`)
   - Add public key to server: `ssh-copy-id admin@YOUR_SERVER_IP`

2. **`SERVER_HOST`**: Your server IP address
   - Example: `35.180.255.192`

3. **`SERVER_USER`**: SSH username
   - Default: `admin`

4. **`DEPLOY_PATH`**: Deployment directory on server
   - Default: `/home/admin/boutique`

### Optional Secrets

- **`VITE_API_URL`**: Backend API URL (defaults to `http://SERVER_HOST:8000`)

## Deployment Methods

### Method 1: Automatic Deployment via GitHub Actions

The deployment workflow runs automatically when you push to the `main` branch.

1. Push your changes to `main`:
   ```bash
   git checkout main
   git merge feature/frontend-ci
   git push origin main
   ```

2. Check deployment status:
   - Go to: https://github.com/Nabil-Bkz/boutique/actions
   - Click on the latest "Deploy to Server" workflow run

### Method 2: Manual Deployment via GitHub Actions

1. Go to: https://github.com/Nabil-Bkz/boutique/actions
2. Click "Deploy to Server" workflow
3. Click "Run workflow"
4. Enter server details and click "Run workflow"

### Method 3: Manual Deployment via Script

1. Make sure you have SSH access configured
2. Set environment variables:
   ```bash
   export SERVER_HOST=35.180.255.192
   export SERVER_USER=admin
   export DEPLOY_PATH=/home/admin/boutique
   ```
3. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## Server List

Available servers for deployment:

- `thierno_hamidou_diallo`: `ssh admin@35.180.255.192`
- `youssef_fathani`: `ssh admin@15.237.53.71`
- `aityoussef_khadija`: `ssh admin@13.38.103.180`
- `alexis_chapusot`: `ssh admin@13.39.160.195`
- `benhammich_salaheddin`: `ssh admin@15.224.18.75`
- `blachere_nicolas`: `ssh admin@35.180.57.114`
- `brahim_naji`: `ssh admin@51.44.222.201`
- `cuny_mederic`: `ssh admin@15.237.192.113`
- `darras_samuel`: `ssh admin@15.224.13.181`
- `demangel_mael`: `ssh admin@51.44.223.10`
- `elidrissi_yassine`: `ssh admin@51.44.161.218`
- `emanuel_fernandes-dos-santos`: `ssh admin@15.237.110.131`
- `inesouldamar`: `ssh admin@15.237.184.100`
- `kaouthar_ASRAR`: `ssh admin@15.188.83.132`
- `meriem_ait_el_achkar`: `ssh admin@15.237.116.188`
- `moretti_thomas`: `ssh admin@15.237.187.180`
- `nougue-ruiz_yoan`: `ssh admin@55.44.164.69`
- `ortega_erwan`: `ssh admin@15.237.196.9`
- `perez_ioann`: `ssh admin@15.236.225.185`
- `ralantonisainana_nyela`: `ssh admin@15.237.255.27`
- `rimhamida`: `ssh admin@13.36.177.216`

## Post-Deployment

After deployment, your application will be available at:

- **Frontend**: `http://YOUR_SERVER_IP/`
- **Backend API**: `http://YOUR_SERVER_IP:8000/api/`
- **Django Admin**: `http://YOUR_SERVER_IP:8000/admin/`

### Check Deployment Status

SSH into your server and run:

```bash
cd /home/admin/boutique
docker ps
docker compose logs
```

### Update Frontend API URL

The frontend needs to know the backend URL. Update the API calls in:
- `frontend/src/api/auth.ts`
- `frontend/src/api/products.ts`
- `frontend/src/api/orders.ts`

Or use environment variables (see next section).

## Troubleshooting

### SSH Connection Issues

```bash
# Test SSH connection
ssh admin@YOUR_SERVER_IP

# Add SSH key to agent
eval $(ssh-agent -s)
ssh-add ~/.ssh/your_private_key
```

### Docker Issues

```bash
# Check Docker status
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker

# View logs
docker compose logs -f
```

### Port Already in Use

```bash
# Check what's using port 8000
sudo lsof -i :8000

# Stop existing containers
docker compose down
```

## Environment Variables

For production, you may want to configure:

- `DEBUG=False` (backend)
- `ALLOWED_HOSTS=YOUR_SERVER_IP` (backend)
- `VITE_API_URL=http://YOUR_SERVER_IP:8000` (frontend build)

