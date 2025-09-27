#!/bin/bash

# 1. Create Dockerfile.dev
cat <<'EOL' > Dockerfile.dev
FROM node:22-slim

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy all source code
COPY . .

# Expose port for NestJS dev
EXPOSE 3000

# Use NestJS watch mode for hot reload
CMD ["npm", "run", "start:dev"]
EOL

echo "Dockerfile.dev created."

# 2. Create docker-compose.dev.yml
cat <<'EOL' > docker-compose.dev.yml
version: "3.9"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    container_name: nest-crud-app-dev
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      NODE_ENV: development

  nginx:
    image: nginx:alpine
    container_name: nest-crud-nginx-dev
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app
EOL

echo "docker-compose.dev.yml created."

# 3. Create nginx/default.conf
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

echo "Development Docker setup is ready!"
echo "Run with: docker-compose -f docker-compose.dev.yml up --build"
