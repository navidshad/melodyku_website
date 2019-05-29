let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
var req = require('request');
const PassThrough = require('stream').PassThrough;

let service = require('./service');
let stream = new Router();
let name = 'stream';

// register a song to has stream access
stream.get('/rg', (ctx) => 
{
    let query = ctx.query;

    // validate
    let bodyValidate = tools.validateObject(query, 'ui si');

    let result;
    if(!bodyValidate.isValid)
        result = tools.reply('f', {'e': bodyValidate.requires, 'm': 'required fields dosnt exist.'});

    else {
        let songId = query.si;
        let userId = query.ui;
        let stamp = service.registerSoungId(userId);
        result = tools.reply('s', {'d': {'stamp':stamp}});
    }

    ctx.body = result;
});

stream.get('/', async (ctx) => 
{
    let query = ctx.query;

    // validate
    let bodyValidate = tools.validateObject(query, 'ai si br ui st org');

    if(!bodyValidate.isValid){
        ctx.throw(404);
        return;
    }

    console.log(ctx.header);
    
    let artistId = query.ai;
    let songId = query.si;
    let bitrate = query.br;
    let userId = query.ui;
    let stamp = query.st;
    let isOrginal = query.org;

    let hasStreamAccess = service.hasAccess(userId, stamp);

    if(!hasStreamAccess) {
        ctx.status = 404;
        return;
    }

    let rootDir = global.config.ftp_convert_dir;
    if(isOrginal == 'true')
        rootDir = global.config.ftp_music_dir;

    let link = `https://data.melodyku.com/${rootDir}/${artistId}/${songId} ${bitrate}.mp3`;

    ctx.body = req(link);
});

module.exports.name = name;
module.exports.main = stream;