# =====================
# Stage 1: Build
# =====================
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first (better cache usage)
COPY package*.json ./

# Install dependencies (faster & reliable for CI/CD)
RUN npm ci

# Copy source code
COPY . .

# Build the app
RUN npm run build


# =====================
# Stage 2: Production
# =====================
FROM nginx:alpine

# Copy built files from builder stage to nginx html folder
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

# nginx starts automatically
