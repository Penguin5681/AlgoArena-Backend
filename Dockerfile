
FROM node:22.17.0


WORKDIR /app


COPY package*.json ./


RUN npm install


RUN npm install -g nodemon


RUN npm install -g typescript


COPY . .


EXPOSE 3001


CMD ["npx", "nodemon", "src/index.ts"]