
const modularRest = require('modular-rest');
let Router = require('koa-router');
let koaBody = require('koa-body');
const koaStatic = require('koa-static');
const cors = require('@koa/cors');
const path = require('path');

// hosts
let http = require('http');
let steryo = require('./../../bot/app.js');
let hostess = require('vhostess')();

// get config
global.config = Object.assign(global.config, require('./config'));
 
let option = {
    root: require('path').join(__dirname, 'routers'),
    onBeforInit: BeforInit, // befor anything
    onInit: Init,           // after collecting routers
    //onAfterInit: AfterInit, // affter launch server
    port: global.config.port,
 
    // if it would be true, app doesn't listen to port,
    // and a raw app object with all routers will be returned.
    // this option is for virtual host middlewares
    dontlisten: true,
 
    // collecting other services from subfolders
    otherSrvice: [
        {
            filename: {name: 'service', extension:'.js'},
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
    // set cors 
    let corsOptions = {
        origin: (ctx) => {
          const requestOrigin = ctx.accept.headers.origin;
          let whitelist = global.config.valid_cors;
          
          if (!whitelist.includes(requestOrigin))
              return ctx.throw(`🙈 ${requestOrigin} is not a valid origin`);
          
          return requestOrigin;
        }
    };
    app.use(cors(corsOptions));
  
    // body parser
    let option = { multipart: true, };
    app.use(koaBody(option));
}

function Init(app, otherSrvice)
{
    // use otherSrvice
    // all your other services will injected to `otherSrvice` object.
    // eahc service would be accessible by its filename
    global.services = otherSrvice['service'];

    // serve static
    let staticFolder_angularApp = '../build';
    let staticFolder = './static';
    app.use(koaStatic(staticFolder_angularApp));
    app.use(koaStatic(staticFolder));
  
    //home url
    let home = new Router();
    home.get('/', (ctx) => {
        ctx.redirect('/index.html');
    });
    app.use(home.routes());
}

function setupVHost(koaApp) 
{
    let port = global.config.port;
    let server = http.createServer(hostess).listen(port);

    global.io = require('socket.io').listen(server);
    
    hostess.use('www.' + global.config.domain_steryo, steryo.app);
    hostess.use(global.config.domain_steryo, steryo.app);
    
    hostess.use('www.' + global.config.domain_melodyku, koaApp.callback());
    hostess.use(global.config.domain_melodyku, koaApp.callback());
    
    // 404 
    hostess.use(function (req, res) {
      res.statusCode = 404
      res.setHeader('Content-Type', 'text/plain; charset=utf-8')
      res.end('subdomain needed')
    });

    // socket connection
    global.io.on('connection', client => 
    {
        console.log('someone connected');
        client.on('event', data => { /* … */ });
        client.on('disconnect', () => { 
            console.log('someone disconnected');
        });

        global.services.converter.initializConverterSockets(client);
    });
}

modularRest.createRest(option).then(async koaApp => 
{   
    console.log('=== rest created');
    // run virtual host
    setupVHost(koaApp);

    // connect to stitch
    await global.services.stitch.login();
  
    // connect to ftp
    global.services.ftp.connect();
  
}).catch(e => {
  console.log('=== rest dosent created');
  console.log(e);
});