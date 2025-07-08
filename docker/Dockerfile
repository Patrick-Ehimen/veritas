# Base image for building the application
FROM node:18-alpine AS base

# Install pnpm
RUN npm install -g pnpm

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND pnpm-lock.yaml are copied
COPY package*.json pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the application
RUN pnpm run build

# Prune dev dependencies
RUN pnpm prune --prod

# Final image
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy the pruned dependencies and built code from the base image
COPY --from=base /usr/src/app/node_modules ./node_modules
COPY --from=base /usr/src/app/apps ./apps
COPY --from=base /usr/src/app/packages ./packages

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD [ "pnpm", "run", "dev" ]
