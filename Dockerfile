FROM node:22.17.0

RUN apt-get update && apt-get install -y \
    default-jdk \
    python3 \
    python3-pip \
    g++ \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm install

RUN npm install -g nodemon

RUN npm install -g typescript

COPY . .

EXPOSE 3001

CMD ["npx", "nodemon", "src/index.ts"]