const PromiseFtp = require('promise-ftp');
let client = new PromiseFtp();
var colog = require('colog');

let name = 'ftp';
let path = require('path');

let rootDir;

async function connect()
{
  let host = global.config.ftp_host;
  let user = global.config.ftp_user;
  let pass = global.config.ftp_pass;
  
  rootDir = '/' + user;

  return client.connect({host: host, user: user, password: pass})
    .then(user => colog.info('- ftp has been connected'))
    .catch(err => colog.error(err) );
}

async function createSubdir(sublist)
{
  //await client.cdup();
  await client.cwd(rootDir).then().catch(e => console.log(`could not goto ${rootDir}`, e));
  
  let currentPath = rootDir;
  for (var i = 0; i < sublist.length; i++) {
    var dir = sublist[i];
    currentPath += `${dir}`;
    
    await client.mkdir(dir).then().catch((e) => {
      console.log(`could not create ${dir}`, e);
    });
    
    await client.cwd(currentPath).then().catch((e) => {
      console.log(`could not goto ${dir}`, e);
    });
  }
  
  await client.cwd(rootDir).then().catch(e => console.log(`could not goto ${rootDir}`, e));
}

async function put(input, destPath)
{
  await client.cwd(rootDir).then().catch(e => console.log(`could not goto ${rootDir}`, e));
  
  await client.put(input, destPath)
    .then(() => {
      //console.log(destPath, ' | has been uploaded.');
    })
    .catch(e => console.log(`could not create ${destPath} | ${e} | ${destPath}`));
}

module.exports.name = name;
module.exports.connect = connect;
module.exports.client = client;
module.exports.createSubdir = createSubdir;
module.exports.put = put;