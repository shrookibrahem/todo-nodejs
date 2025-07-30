
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:20-slim

WORKDIR /app

COPY --from=builder /app .

EXPOSE 4000

CMD ["npm", "start"]
