FROM node:10-alpine

ADD packages/test1.jar /esf/test1.jar
ADD packages/test2.jar /esf/test2.jar
ADD packages/server.js /esf/server.js
ADD packages/package.json /esf/package.json

RUN cd /esf && npm install

EXPOSE 5000
CMD [ "npm", "start" ]