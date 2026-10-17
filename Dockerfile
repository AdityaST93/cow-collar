FROM node:22-alpine
WORKDIR /app
COPY package.json ./
COPY shared ./shared
COPY server ./server
COPY web ./web
RUN mkdir -p /app/data && chown -R node:node /app/data
USER node
ENV PORT=3000 DATA_DIR=/app/data
EXPOSE 3000
VOLUME /app/data
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:3000/healthz || exit 1
CMD ["node", "server/server.js"]
