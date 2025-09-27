#!/bin/bash

# Create Dockerfile
cat <<'EOL' > Dockerfile
# Stage 1: Build the application
FROM node:22-slim AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all source code
COPY . .

# Build the NestJS app
RUN npm run build

# Stage 2: Production image
FROM node:22-slim

WORKDIR /app

# Copy only production files
COPY package*.json ./
RUN npm install --only=production

# Copy compiled files from builder
COPY --from=builder /app/dist ./dist

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "dist/main.js"]
EOL

echo "Dockerfile created."

# Create docker-compose.yml
cat <<'EOL' > docker-compose.yml
version: "3.9"

services:
  app:
    build: .
    container_name: nest-crud-app
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production

  nginx:
    image: nginx:alpine
    container_name: nest-crud-nginx
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app
EOL

echo "docker-compose.yml created."

# Create nginx directory and default.conf
mkdir -p nginx

cat <<'EOL' > nginx/default.conf
server {
    listen 80;

    server_name localhost;

    location / {
        proxy_pass http://app:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOL

echo "nginx/default.conf created."

echo "All Docker and Nginx files created successfully!"
