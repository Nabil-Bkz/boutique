#!/bin/bash
set -e

# Configuration
SERVER_HOST="${SERVER_HOST:-35.180.255.192}"
SERVER_USER="${SERVER_USER:-admin}"
DEPLOY_PATH="${DEPLOY_PATH:-/home/admin/boutique}"

echo "🚀 Deploying to $SERVER_USER@$SERVER_HOST"

# Copy files to server
echo "📦 Copying files to server..."
rsync -avz --delete \
  --exclude '.git' \
  --exclude 'node_modules' \
  --exclude '__pycache__' \
  --exclude '*.pyc' \
  --exclude '.pytest_cache' \
  --exclude 'db.sqlite3' \
  ./ $SERVER_USER@$SERVER_HOST:$DEPLOY_PATH/

# Deploy on server
echo "🐳 Deploying with Docker Compose..."
ssh $SERVER_USER@$SERVER_HOST << EOF
  set -e
  cd $DEPLOY_PATH
  
  # Ensure Docker and Docker Compose are installed
  if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed on the server"
    exit 1
  fi
  
  # Pull latest images and restart services
  docker compose up -d --build || docker-compose up -d --build
  
  # Show running containers
  echo "✅ Deployment complete! Running containers:"
  docker ps
  
  # Show logs
  echo "📋 Recent logs:"
  docker compose logs --tail=50 || docker-compose logs --tail=50
EOF

echo "✅ Deployment successful!"

