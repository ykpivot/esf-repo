var express = require('express')
var app = express();
app.use("/configs", express.static(__dirname + '/configs'));

var port = 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});