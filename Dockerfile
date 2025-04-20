FROM node:16

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

# Copy dependency files first to leverage Docker layer caching
COPY package.json .
COPY yarn.lock .

# Optional: use network host during build only if you're building with --network=host
# You can also add a debug curl step before yarn install to confirm registry access
RUN curl -IL https://registry.yarnpkg.com && yarn install --network-timeout 600000

# Then copy the rest of the source files
COPY . .

# Run your app
CMD ["yarn", "start"]
