# Multi-stage Dockerfile for Pizza Shop MERN App
FROM node:20-alpine AS builder

WORKDIR /app

# Copy root dependencies and install
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy frontend dependencies and install
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm install --legacy-peer-deps

# Copy source code
COPY . .

# Build backend and frontend
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production --legacy-peer-deps

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/frontend/build ./frontend/build

EXPOSE 5000

ENV PORT=5000
ENV NODE_ENV=production

CMD ["npm", "start"]
