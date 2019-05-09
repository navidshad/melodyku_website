let Router = require('koa-router');
let restTools = require('modular-rest-toolkit');
let name = 'songProvider';

let search = new Router();
search.get('/', (ctx) => {
    ctx.body = 'send me a post request';
});

search.post('/', (ctx) => {
    ctx.body = `Request Body: ${JSON.stringify(ctx.request.body)}`;
})

module.exports.name = name;
module.exports.main = search;