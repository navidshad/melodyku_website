var colog = require('colog');
let name = 'stitchClonerDB';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

let connectionStr = global.config.stitch_cloner_conectionString;
const connection = mongoose.createConnection(connectionStr);
connection.on('connected', () => colog.info('- stitchClonerDB has been connected'));

module.exports.name = name;

module.exports.artist = connection.model('artist', new Schema({}, {strict: false}));
module.exports.album = connection.model('album', new Schema({}, {strict: false}));
module.exports.song = connection.model('song', new Schema({}, {strict: false}));
module.exports.song_favorite = connection.model('song_favorite', new Schema({}, {strict: false}));
module.exports.song_history = connection.model('song_history', new Schema({}, {strict: false}));