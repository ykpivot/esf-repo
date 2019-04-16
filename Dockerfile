FROM node:10-alpine

ADD source/packages/test1.jar /esf/test1.jar
ADD source/packages/test2.jar /esf/test2.jar
ADD source/packages/server.js /esf/server.js
ADD source/packages/package.json /esf/package.json

RUN cd /esf && npm install

EXPOSE 5000
CMD [ "npm", "start" ]