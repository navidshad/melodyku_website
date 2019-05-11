
const modularRest = require('modular-rest');
let Router = require('koa-router');
let koaBody = require('koa-body');
const koaStatic = require('koa-static');
const cors = require('@koa/cors');
const path = require('path');
 
let option = {
    root: require('path').join(__dirname, 'routers'),
    onBeforInit: BeforInit, // befor anything
    onInit: Init,           // after collecting routers
    onAfterInit: AfterInit, // affter launch server
    port: 1362,
 
    // if it would be true, app doesn't listen to port,
    // and a raw app object with all routers will be returned.
    // this option is for virtual host middlewares
    dontlisten: true,
 
    // collecting other services from subfolders
    otherSrvice: [
        {
            filename: {name: 'fn', extension:'.js'},
            rootDirectory: require('path').join(__dirname, 'routers'),
            option: {
                    // if this option woulde be true, the property of each service will be attached to rootObject
                    // the `name` property will be rejected and only the main property of each service would be recognize.
                    // it would be useful when you want to collect all mongoose models in one root object.
                    combineWithRoot: false,
 
                    // convert the rootObject to an array
                    // the `name` property will be rejected and only the main property of each service would be recognize.
                    convertToArray: false,
                }
        }
    ],
};
 
function BeforInit(app)
{
    // do something
}
 
function Init(app, otherSrvice)
{
    // use otherSrvice
    // all your other services will injected to `otherSrvice` object.
    // eahc service would be accessible by its filename
    global.services = otherSrvice['fn'];

    // set cors 
	app.use(cors());
	
    //home url
    let home = new Router();
    home.get('/', (ctx) => {
        ctx.redirect('/index.html');
    });
    app.use(home.routes());

    // body parser
    app.use(koaBody());

    // serve static
    let staticFolder_angularApp = '../build';
    let staticFolder = './static';
    app.use(koaStatic(staticFolder_angularApp));
    app.use(koaStatic(staticFolder));
}
 
function AfterInit(app, otherSrvice) {
  // do something
}

// hosts
let http = require('http');
let steryo = require('./../../bot/app.js');
let hostess = require('vhostess')();

modularRest.createRest(option).then(koaApp => 
{
    // do something
  http.createServer(hostess).listen(80);
  hostess.use('melodyku.com', koaApp.callback());
  hostess.use('steryo.melodyku.com', steryo.app);
  hostess.use(function (req, res) {
    res.statusCode = 404
    res.setHeader('Content-Type', 'text/plain; charset=utf-8')
    res.end('subdomain needed')
  });
});