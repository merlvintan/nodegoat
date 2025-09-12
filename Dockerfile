# syntax=docker/dockerfile:1

# Build + prod runtime in one (simple app, no separate build step)
FROM node:20-alpine AS runtime
WORKDIR /app

# App runs on 4000 (NodeGoat default)
ENV NODE_ENV=production
ENV PORT=4000
# Safe default for local/docker-compose; override in CI/Prod
ENV MONGODB_URI="mongodb://mongo:27017/nodegoat"

# Install only the deps needed to run
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev || npm install --production

# Copy source
COPY . .

# Drop privileges (built-in non-root user in the base image)
USER node

EXPOSE 4000
# NodeGoat uses npm start -> server.js
CMD ["npm","start"]
