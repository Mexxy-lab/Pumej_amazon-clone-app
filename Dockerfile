# ---------- Build Stage ----------
    FROM node:18-slim AS builder

    WORKDIR /usr/src/app
    
    # Copy dependency files first
    COPY package.json yarn.lock ./
    
    # Install all dependencies (for building)
    RUN yarn install --frozen-lockfile --network-timeout 600000
    
    # Copy app source code
    COPY . .
    
    # Build the React app
    RUN yarn build
    
    # ---------- Production Stage ----------
    FROM nginx:alpine AS production
    
    # Copy built assets from builder
    COPY --from=builder /usr/src/app/build /usr/share/nginx/html
    
    # Copy custom nginx config if you have one
    # COPY nginx.conf /etc/nginx/nginx.conf
    
    # Expose port 80
    EXPOSE 80
    
    # Start nginx
    CMD ["nginx", "-g", "daemon off;"]
    