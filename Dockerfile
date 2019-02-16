FROM node:10-alpine

ADD esf-repo/packages/test1.jar /esf/test1.jar
ADD esf-repo/packages/test2.jar /esf/test2.jar
ADD esf-repo/packages/server.js /esf/server.js
ADD esf-repo/packages/package.json /esf/package.json
ADD config-files/var-config.xml /esf/configs/var-config.xml

RUN cd /esf && npm install

EXPOSE 5000
CMD [ "npm", "start" ]