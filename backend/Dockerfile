# =========================
# Stage 1: Dependencies
# =========================
FROM node:20-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev


# =========================
# Stage 2: Production
# =========================
FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=5000

# Create a non-root user
RUN addgroup -S nodejs && adduser -S nodeuser -G nodejs

# Copy only production dependencies
COPY --from=dependencies /app/node_modules ./node_modules

# Copy application source
COPY --chown=nodeuser:nodejs src ./src
COPY --chown=nodeuser:nodejs package*.json ./

# Run as non-root
USER nodeuser

EXPOSE 5000

# Container health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:5000/healthz || exit 1

CMD ["node", "src/server.js"]
