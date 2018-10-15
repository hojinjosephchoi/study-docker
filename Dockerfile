FROM node:7.7.1

WORKDIR /app
ADD    ./package.json         /app/
RUN    npm install

ADD    ./src/                 /app/src/

CMD ["node", "src/app.js"]
