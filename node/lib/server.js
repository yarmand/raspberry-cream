var express = require("express");
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io').listen(server);
var path = require('path');

app.use(express.bodyParser());
server.listen(8000);

var publicPath = path.join(__dirname, '/../public');

app.get('/', function (req, res) {
  res.sendfile(publicPath + "/frame.html");
});

app.get('/admin', function (req, res) {
  res.sendfile(publicPath + "/form.html");
});

app.get('/ip', function (req, res) {
  var os=require('os');
  var ifaces=os.networkInterfaces();

  var ips = [];

  for (var dev in ifaces) {
    ifaces[dev].forEach(function(details){
      if (details.family==='IPv4' && dev.indexOf("lo") !== 0) {
        ips.push(dev + ": " + details.address);
      }
    });
  }

  res.send(ips.join(", "));
});

app.post('/browser/url', function(req, res){
  var url = req.body.url;
  io.sockets.emit('url', url);
  res.send(200);
});