let toolkit = require('modular-rest-toolkit');
let Router = require('koa-router');
let name = 'converter';

var fn = require('./fn');
let convert = new Router();

module.exports.name = name;
module.exports.main = convert;

// a list of no converted medias
convert.post('/list', async (ctx) => 
{
    let body = ctx.request.body;
    var preset = body.preset;
    var page = parseInt(body.page);
    var total = parseInt(body.total);
    
    var result = await fn.getlist(total, page, preset)
        .then(songs => {
            return toolkit.reply('s', {'d': songs});
        })
        .catch(e => {
            return toolkit.reply('e', {'e': e});
        });

    ctx.body = result;
});

// convert a media
convert.post('/convert', async (ctx) => 
{
    let body = ctx.request.body;
    var preset = body.preset;
    var id = body.id;
    
    var result = await fn.prepareToCovert(id, preset)
        .then(r => {
            return toolkit.reply('s', {'d': r});
        })
        .catch(e => {
            return toolkit.reply('e', {'e': e});
        });

    ctx.body = result;
});

// get config list
// convert.get('/getConfigs', async (ctx) => 
// {
//     let body = ctx.request.body;
//     var result = await fn.getConfigs();
//     ctx.body = result;
// });

// create a  config
// convert.post('/createConf', async (ctx) => 
// {
//     let body = ctx.request.body;
//     var config = body;
//     var result = await fn.createConf(config);
//     ctx.body = result;
// });

// // remove  config
// convert.post('/removeConf', async (ctx) => 
// {
//     let body = ctx.request.body;
//     var id = body.id
//     var result = await fn.removeConf(id);
//     ctx.body = result;
// });