
var env = require('dotenv').config({ path: '../.env' }),

    redis_host = process.env.REDIS_HOST
        ? process.env.REDIS_HOST
        : '127.0.0.1',

    redis_port = process.env.REDIS_PORT
        ? process.env.REDIS_PORT
        : 6379,

    socket_port = process.env.SOCKET_PORT
        ? process.env.SOCKET_PORT
        : 9002;


var http = require('http'),
    ioServer = require('socket.io'),
    io = new ioServer(),
    redis = require('ioredis')(redis_port, redis_host),
    httpServer;


try {

    httpServer = http.createServer();

    httpServer.listen(socket_port, '127.0.0.1');

    io.attach(httpServer);

    console.log(
        'Socket.IO server running on 127.0.0.1:' + socket_port
    );

}
catch (err) {

    console.log(err.message);

}


io.sockets.on('connection', function(socket) {

    socket.on('join', function(room) {

        socket.join(room);

    });

});


redis.psubscribe('*', function(err, count) {

    if (err) {
        console.log('Redis subscribe error:', err.message);
    }

});


redis.on('pmessage', function(subscribed, channel, message) {

    try {

        message = JSON.parse(message);

        io.sockets.in(channel).emit(
            message.event,
            message.data
        );

    }
    catch (err) {

        console.log(
            'Redis message error:',
            err.message
        );

    }

});

