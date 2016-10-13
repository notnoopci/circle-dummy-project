var http = require('http');
var redis = require('redis').createClient(6379, 'redis');

http.createServer(function (req, res) {
	redis.incr('counter', function () {
		redis.get('counter', function (err, counter) {
            console.log('counter @', counter);
            res.end(counter);	
		});
	});
}).listen(8080);
