FROM node:18

ENV APP_ID phitnest-api
ENV PORT 3000
ENV LOG_LEVEL=debug
ENV REQUEST_LIMIT 100kb
ENV MONGODB_URI mongodb+srv://phitnest:8o0r1F5yq3NpJ0Nj@phitnestdev.fa8jd0b.mongodb.net/dev
ENV AWS_REGION us-east-1
ENV COGNITO_POOL_ID us-east-1_QtwaFWgOF
ENV COGNITO_APP_CLIENT_ID 3jvksv0j08j619v7t0sp7631ak

WORKDIR /app 
COPY package.json /app 
COPY yarn.lock /app
RUN yarn install 
COPY . /app 
RUN yarn compile
EXPOSE 3000
CMD ["yarn", "start"]