var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var configsSchema = new Schema({
  name:       String,
  type:       {type:String, default:'mp3'},
  input:      String,
  output:     String,
});

module.exports.conf = mongoose.model('convertConfigs', configsSchema);
