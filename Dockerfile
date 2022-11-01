FROM node:18
WORKDIR /app 
COPY package.json /app 
COPY yarn.lock /app
COPY .env /app
RUN yarn install 
COPY . /app 
RUN yarn compile
CMD ["yarn", "start"]
EXPOSE 443