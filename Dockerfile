FROM node:22-bookworm-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-bookworm-slim AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=build /app/package*.json ./
RUN npm ci
COPY --from=build /app/dist ./dist
COPY --from=build /app/.openai ./.openai
EXPOSE 3000
CMD ["npm", "run", "web:start"]
