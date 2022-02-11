FROM node:7.9

WORKDIR /usr/src/app

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

#CMD [ "npm", "run", "start-server" ]
#CICD
# replace this with your application's default port
EXPOSE 8080
