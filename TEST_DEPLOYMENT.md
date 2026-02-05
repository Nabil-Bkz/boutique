# Testing Backend and Frontend Deployment via CI/CD

This guide shows you how to deploy both backend and frontend to your server and test them using CI/CD.

## 🎯 Overview

The CI/CD pipeline will:
1. ✅ Run backend tests (linting, formatting, unit tests)
2. ✅ Run frontend tests (linting, unit tests)
3. ✅ Deploy both backend and frontend to your server
4. ✅ Run health checks to verify deployment

## 📋 Prerequisites

### 1. GitHub Secrets Setup

Go to: https://github.com/Nabil-Bkz/boutique/settings/secrets/actions

Add these secrets:

| Secret Name | Description | Example |
|------------|-------------|---------|
| `SSH_PRIVATE_KEY` | Your SSH private key | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `SERVER_HOST` | Server IP address | `35.180.255.192` |
| `SERVER_USER` | SSH username | `admin` |
| `DEPLOY_PATH` | Deployment directory (optional) | `/home/admin/boutique` |

### 2. Server Setup

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
```

### 3. SSH Key Setup

Generate SSH key for GitHub Actions (if you haven't already):

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_key -N ""

# Display private key (copy to GitHub secret SSH_PRIVATE_KEY)
cat ~/.ssh/github_actions_key

# Add public key to server
ssh-copy-id -i ~/.ssh/github_actions_key.pub admin@YOUR_SERVER_IP
```

## 🚀 Deployment Methods

### Method 1: Automatic Deployment (Push to main)

1. **Commit and push your changes:**
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git push origin main
   ```

2. **Watch the deployment:**
   - Go to: https://github.com/Nabil-Bkz/boutique/actions
   - Click on the latest "Deploy to Server" workflow run
   - You'll see:
     - ✅ `test-backend` - Backend CI tests
     - ✅ `test-frontend` - Frontend CI tests
     - ✅ `deploy` - Deployment to server
     - ✅ Health checks

### Method 2: Manual Deployment via GitHub Actions

1. Go to: https://github.com/Nabil-Bkz/boutique/actions
2. Click "Deploy to Server" workflow
3. Click "Run workflow"
4. Enter:
   - Server IP: `35.180.255.192` (or your server)
   - SSH User: `admin`
5. Click "Run workflow"

### Method 3: Manual Deployment via Script

```bash
export SERVER_HOST=35.180.255.192
export SERVER_USER=admin
export DEPLOY_PATH=/home/admin/boutique
./deploy.sh
```

## ✅ Testing the Deployment

### 1. Check GitHub Actions Status

After deployment, check:
- https://github.com/Nabil-Bkz/boutique/actions
- All jobs should show ✅ green checkmarks

### 2. Verify on Server

SSH into your server:

```bash
ssh admin@YOUR_SERVER_IP
cd /home/admin/boutique

# Check running containers
docker ps

# Expected output:
# CONTAINER ID   IMAGE                    STATUS         PORTS                    NAMES
# xxxxx          boutique-frontend        Up 2 minutes   0.0.0.0:80->80/tcp      boutique-frontend
# xxxxx          boutique-backend         Up 2 minutes   0.0.0.0:8000->8000/tcp   boutique-backend

# Check logs
docker compose logs backend
docker compose logs frontend

# Check health
docker compose ps
```

### 3. Test Backend API

```bash
# Test products endpoint
curl http://YOUR_SERVER_IP:8000/api/products/

# Expected: JSON array of products

# Test admin endpoint
curl http://YOUR_SERVER_IP:8000/admin/

# Expected: HTML page (Django admin login)
```

### 4. Test Frontend

Open in browser:
- **Frontend**: http://YOUR_SERVER_IP/
- **Backend API**: http://YOUR_SERVER_IP:8000/api/products/
- **Admin Panel**: http://YOUR_SERVER_IP:8000/admin/

### 5. Test Full Application Flow

1. **Visit Frontend**: http://YOUR_SERVER_IP/
   - Should see product list
   - Products should load from backend API

2. **Register/Login**: 
   - Click login/register
   - Create account or login
   - Should authenticate with backend

3. **Browse Products**:
   - Click on products
   - Should see product details

4. **Checkout**:
   - Add product to cart
   - Complete checkout
   - Should create order in backend

5. **Admin Panel**:
   - Visit http://YOUR_SERVER_IP:8000/admin/
   - Login with superuser credentials
   - Should see orders and products

## 🔍 Troubleshooting

### CI Tests Fail

**Backend tests fail:**
```bash
# Run locally to debug
cd backend
uv sync --extra dev
cd core
uv run python manage.py test
```

**Frontend tests fail:**
```bash
# Run locally to debug
cd frontend
npm ci
npm run lint
npm test -- --run
```

### Deployment Fails

**SSH Connection Issues:**
```bash
# Test SSH manually
ssh admin@YOUR_SERVER_IP

# Check SSH key
ssh-add -l
```

**Docker Issues:**
```bash
# Check Docker on server
ssh admin@YOUR_SERVER_IP
docker ps
docker compose version
```

**Port Already in Use:**
```bash
# Stop existing containers
ssh admin@YOUR_SERVER_IP
cd /home/admin/boutique
docker compose down
```

### Backend Not Accessible

**Check ALLOWED_HOSTS:**
```bash
# On server, check environment
docker compose exec backend env | grep ALLOWED_HOSTS

# Should show: ALLOWED_HOSTS=YOUR_SERVER_IP,localhost,127.0.0.1
```

**Check Backend Logs:**
```bash
docker compose logs backend
```

### Frontend Can't Connect to Backend

**Check API URL:**
- Frontend is built with `VITE_API_URL=http://YOUR_SERVER_IP:8000`
- Verify in browser console (F12 → Network tab)
- Check if API calls are going to correct URL

**Check CORS:**
- Backend has `CORS_ALLOW_ALL_ORIGINS = True`
- Should allow requests from frontend

**Test Backend Directly:**
```bash
curl http://YOUR_SERVER_IP:8000/api/products/
```

## 📊 CI/CD Pipeline Flow

```
Push to main
    ↓
┌─────────────────┐
│  test-backend   │ ← Backend CI (lint, format, tests)
└─────────────────┘
    ↓
┌─────────────────┐
│ test-frontend   │ ← Frontend CI (lint, tests)
└─────────────────┘
    ↓
┌─────────────────┐
│     deploy      │ ← Deploy to server
│  - Copy files   │
│  - Build images │
│  - Start containers │
└─────────────────┘
    ↓
┌─────────────────┐
│  health-check   │ ← Verify deployment
└─────────────────┘
    ↓
✅ Deployment Complete!
```

## 🎉 Success Indicators

You'll know deployment succeeded when:

1. ✅ All GitHub Actions jobs show green checkmarks
2. ✅ `docker ps` shows both containers running
3. ✅ Frontend loads at http://YOUR_SERVER_IP/
4. ✅ Backend API responds at http://YOUR_SERVER_IP:8000/api/products/
5. ✅ Frontend can fetch products from backend
6. ✅ You can login/register
7. ✅ You can create orders

## 🔄 Updating Deployment

To update your deployment:

1. Make changes to code
2. Commit and push to `main`
3. CI/CD will automatically:
   - Run tests
   - Deploy if tests pass
   - Update containers on server

No manual intervention needed! 🚀

