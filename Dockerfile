# ---------- Build Stage ----------
    FROM node:18-slim AS builder

    ARG NODE_ENV=production
    ENV NODE_ENV=${NODE_ENV}
    
    # Install dependencies for native builds if needed
    RUN apt-get update && apt-get install -y \
        curl \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /usr/src/app
    
    # Copy only dependency-related files first
    COPY package.json yarn.lock ./
    
    # Install production dependencies
    RUN yarn install --frozen-lockfile --production --network-timeout 600000
    
    # ---------- Production Stage ----------
    FROM node:18-slim AS production
    
    ARG NODE_ENV=production
    ENV NODE_ENV=${NODE_ENV}
    
    WORKDIR /usr/src/app
    
    # Copy only node_modules from builder
    COPY --from=builder /usr/src/app/node_modules ./node_modules
    
    # Copy the app source
    COPY . .
    
    # Optional: remove dev-only files (like .env, test folders, etc.)
    # RUN rm -rf tests/ .env.dev
    
    CMD ["yarn", "start"]
    