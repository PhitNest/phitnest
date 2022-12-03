FROM node:18

WORKDIR /app 
COPY package.json /app 
RUN yarn install 
COPY . /app 
RUN yarn compile
EXPOSE 3000
CMD ["yarn", "start"]