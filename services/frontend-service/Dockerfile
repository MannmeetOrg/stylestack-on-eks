FROM node:20

WORKDIR /app

COPY package.json .
RUN npm install

COPY app.js .

EXPOSE 8080

CMD ["node", "app.js"]


## Build stage
#FROM node:20 AS builder
#
#WORKDIR /app
#COPY package.json .
#RUN npm install
#COPY . .
#
## Production image
#FROM node:20-slim
#
#WORKDIR /app
#COPY --from=builder /app /app
#
#EXPOSE 8080
#CMD ["node", "app.js"]
