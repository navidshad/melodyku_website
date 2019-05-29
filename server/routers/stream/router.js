let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
var req = require('request');
const PassThrough = require('stream').PassThrough;

let service = require('./service');
let stream = new Router();
let name = 'stream';

// register a song to has stream access
// stream.get('/rg', (ctx) => 
// {
//     let query = ctx.query;

//     // validate
//     let bodyValidate = tools.validateObject(query, 'ui si');

//     let result;
//     if(!bodyValidate.isValid)
//         result = tools.reply('f', {'e': bodyValidate.requires, 'm': 'required fields dosnt exist.'});

//     else {
//         let songId = query.si;
//         let userId = query.ui;
//         let stamp = service.registerSoungId(userId, ctx.header);
//         result = tools.reply('s', {'d': {'stamp':stamp}});
//     }

//     //console.log(ctx.header);

//     ctx.body = result;
// });

stream.get('/', async (ctx) => 
{
    let query = ctx.query;

    // validate
    let bodyValidate = tools.validateObject(query, 'ai si br org');

    if(!bodyValidate.isValid){
        ctx.throw(404);
        return;
    }

    let hasStreamAccess = (ctx.header['range']) ? true : false;
    if(!hasStreamAccess) {
        ctx.throw(404);
        return;
    }

    console.log(ctx.header);
    
    let artistId = query.ai;
    let songId = query.si;
    let bitrate = query.br;
    let isOrginal = query.org;

    let rootDir = global.config.ftp_convert_dir;
    if(isOrginal == 'true')
        rootDir = global.config.ftp_music_dir;

    let link = `https://data.melodyku.com/${rootDir}/${artistId}/${songId} ${bitrate}.mp3`;

    ctx.body = req(link);
});

module.exports.name = name;
module.exports.main = stream;