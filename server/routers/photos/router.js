let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
let name = 'photos';

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
        await service.uploadPhotos(body.type, body.id, file.photo)
            .then(() => {
                result = tools.reply('s');
            })
            .catch((e) => {
                result = tools.reply('e', {'e': e});
            }); 
    }

    ctx.body = result;
});

module.exports.name = name;
module.exports.main = photos;