let Router = require('koa-router');
let restTools = require('modular-rest-toolkit');
let name = 'rd';

let redirect = new Router();
redirect.get('/', (ctx) => 
{
	let query = ctx.query;

	let path = '/#';
	Object.keys(query).forEach((key) => {
		if(key == 'page') path += `/${query[key]}`;
		else path += `/${key}/${query[key]}`;
	});

	ctx.redirect(path);
    //ctx.body = 'send me a post request';
});

module.exports.name = name;
module.exports.main = redirect;