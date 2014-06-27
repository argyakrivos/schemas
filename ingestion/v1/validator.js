var tv4 = require('tv4');
var fs = require('fs');

var schema = fs.readFileSync(__dirname + '/contributor.schema.json', "utf8");
var data = fs.readFileSync(__dirname + '/image_upload.contributor.json', "utf8");

var result = tv4.validateMultiple(data, schema);

console.log(result);