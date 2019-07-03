let Router = require('koa-router');
let koaBody = require('koa-body');

let {validateObject, reply} = require('modular-rest-toolkit');
let name = 'stitchCloner';

let db = require('./service');

let stitchCloner = new Router();
stitchCloner.post('/find', async (ctx) => 
{
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection query');

    // fields validation
    if(!bodyValidate.isValid)
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':bodyValidate.requires})), 412);
    }
    else if(!db.hasOwnProperty(body.collection))
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':'wrong collection'})), 412);
    }

    // operate on db
    await db[body.collection].find(body.query, body.projection, body.options).exec()
        .then(docs => ctx.body = docs)
        .catch(err => {
          ctx.status = err.status || 500;
          ctx.body = err.message;
        });
});

stitchCloner.post('/count', async (ctx) => 
{
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection query');

    // fields validation
    if(!bodyValidate.isValid)
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':bodyValidate.requires})), 412);
    }
    else if(!db.hasOwnProperty(body.collection))
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':'wrong collection'})), 412);
    }

    // operate on db
    await db[body.collection].countDocuments(body.query).exec()
        .then(docs => ctx.body = docs)
        .catch(err => {
          ctx.status = err.status || 500;
          ctx.body = err.message;
        });
});

stitchCloner.post('/updateOne', async (ctx) => 
{
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection query update');

    // fields validation
    if(!bodyValidate.isValid)
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':bodyValidate.requires})), 412);
    }
    else if(!db.hasOwnProperty(body.collection))
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':'wrong collection'})), 412);
    }

    // operate on db
    await db[body.collection].updateOne(body.query, body.update, body.options).exec()
        .then((writeOpResult) => 
            ctx.body = reply('s', {'d': writeOpResult}))
        .catch(err => {
          ctx.status = err.status || 500;
          ctx.body = err.message;
        });
});

stitchCloner.post('/insertOne', async (ctx) => 
{
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection doc');

    // fields validation
    if(!bodyValidate.isValid)
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':bodyValidate.requires})), 412);
    }
    else if(!db.hasOwnProperty(body.collection))
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':'wrong collection'})), 412);
    }

    // operate on db
    await new db[body.collection](body.doc).save()
        .then((writeOpResult) => 
            ctx.body = reply('s', {'d': writeOpResult}))
        .catch(err => {
          ctx.status = err.status || 500;
          ctx.body = err.message;
        });
});

stitchCloner.post('/removeOne', async (ctx) => 
{
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection id');

    // fields validation
    if(!bodyValidate.isValid)
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':bodyValidate.requires})), 412);
    }
    else if(!db.hasOwnProperty(body.collection))
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':'wrong collection'})), 412);
    }

    // operate on db
    await db[body.collection].findOneAndRemove(body.id).exec()
        .then((result) => 
            ctx.body = reply('s', {'d': result}))
        .catch(err => {
          ctx.status = err.status || 500;
          ctx.body = err.message;
        });
});

stitchCloner.post('/aggregate', async (ctx) => 
{
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection piplines');

    // fields validation
    if(!bodyValidate.isValid)
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':bodyValidate.requires})), 412);
    }
    else if(!db.hasOwnProperty(body.collection))
    {
        ctx.throw(JSON.stringify(
            reply('e', {'e':'wrong collection'})), 412);
    }

    // operate on db
    await db[body.collection].aggregate(body.piplines).exec()
        .then((result) => 
            ctx.body = reply('s', {'d': result}))
        .catch(err => {
          ctx.status = err.status || 500;
          ctx.body = err.message;
        });
});

module.exports.name = name;
module.exports.main = stitchCloner;