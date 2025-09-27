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
