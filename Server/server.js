var WebSocketServer = require('websocket').server;
var http = require('http');
var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
    response.writeHead(404);
    response.end();
});
server.listen(8890, function() {
    console.log((new Date()) + ' Server is listening on port 8890');
});

wsServer = new WebSocketServer({
    httpServer: server,
    autoAcceptConnections: false
});

process.on('uncaughtException', function(e) {
    console.log(e);
});

var clients = [];

wsServer.on('request', function(request) {
    var connection = request.accept(request.origin);
    clients.push(connection);
    console.log((new Date()) + ' Connection accepted.');
    connection.on('message', function(message) {
        console.log('Log: ' + message.utf8Data);
        if (message.type === 'utf8') {
            clients.forEach(function(client) {
                client.sendUTF(message.utf8Data);
            });
        }
    });
    connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});
