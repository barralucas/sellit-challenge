FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Build application
RUN npm run build

# Production image
FROM node:18-alpine AS runner

WORKDIR /app

# Copy built application
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

# Install production dependencies
RUN npm ci --only=production

# Expose port
EXPOSE 3000

# Start application
CMD ["npm", "start"]
