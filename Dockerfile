FROM node:18

WORKDIR /app 
COPY package.json /app 
COPY yarn.lock /app
RUN yarn install 
COPY . /app 
RUN yarn compile
EXPOSE 3000
CMD ["yarn", "start"]