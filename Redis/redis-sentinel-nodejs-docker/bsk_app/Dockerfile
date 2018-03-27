FROM   node:6.9.2
EXPOSE 8080
COPY   ["apud", "/usr/src/apud"]
RUN    cd /usr/src/apud && npm install
CMD    ["node", "/usr/src/apud/bin/index.js"]
