const config = require('./config.json');

const express = require('express');
const ParseServer = require('parse-server').ParseServer;

const app = express();
const api = new ParseServer({
    ...config,
    allowHeaders: ['X-Parse-Installation-Id', 'X-Parse-Client-Key'],
    liveQuery: {
        classNames: ["Room", "Step"]
    }
});

// Serve the Parse API at /parse URL prefix
app.use('/parse', api);

const port = 1337;
let httpServer = require('http').createServer(app);
httpServer.listen(port);
var parseLiveQueryServer = ParseServer.createLiveQueryServer(httpServer);