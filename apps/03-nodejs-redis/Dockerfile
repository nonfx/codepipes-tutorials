# build stage
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm install --production=false --frozen-lockfile
COPY . .
RUN npm run build

# production stage
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install --production --frozen-lockfile
COPY --from=build /app/dist ./dist
COPY --from=build /app/views ./views

CMD ["npm", "start"]
