let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
let name = 'image';

let service = require('./service');
let photos = new Router();

photos.post('/upload', async (ctx) => 
{
    let body = ctx.request.body;
    let file = ctx.request.files;

    // validate
    let bodyValidate = tools.validateObject(body, { 'type': 'artist album song user playlist', 'id': ''});

    let result;

    if(!bodyValidate.isValid) 
        result = tools.reply('f',  {'m': 'some fileds required.', 'e': bodyValidate.requires});
    
    else  {
        await service.uploadPhoto(body.type, body.id, file.image)
            .then(() => {
                result = tools.reply('s');
            })
            .catch((e) => {
                result = tools.reply('e', {'e': e});
            }); 
    }

    console.log('upload', result);
    ctx.body = result;
});

photos.post('/remove', async (ctx) => 
{
    let body = ctx.request.body;

    // validate
    let bodyValidate = tools.validateObject(body, { 'type': 'artist album song user playlist', 'id': ''});

    let result;

    if(!bodyValidate.isValid) 
        result = tools.reply('f',  {'m': 'some fileds required.', 'e': bodyValidate.requires});
    
    else  {
        await service.removePhoto(body.type, body.id)
            .then(() => {
                result = tools.reply('s');
            })
            .catch((e) => {
                result = tools.reply('e', {'e': e});
            }); 
    }

    console.log('remove', result);
    ctx.body = result;
});

module.exports.name = name;
module.exports.main = photos;