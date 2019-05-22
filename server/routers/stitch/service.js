var colog = require('colog');
let name = 'stitch';

const {
    Stitch,
    ServerApiKeyCredential,
    RemoteMongoClient,
    BSON,
} = require('mongodb-stitch-server-sdk');

const{ 
    RemoteUpdateOptions
} = require("mongodb-stitch-core-services-mongodb-remote");

let configDetail = global.config;

let stitchClient;
let mongoClient;

function login()
{
  stitchClient = Stitch.initializeDefaultAppClient(configDetail.stitch_appid);
  mongoClient = stitchClient.getServiceClient(RemoteMongoClient.factory, configDetail.stitch_service);
  
  let credential = new ServerApiKeyCredential(configDetail.stitch_api_key);
  return stitchClient.auth.loginWithCredential(credential)
    .then(user => colog.info('- stitch_db has been connected'))
    .catch(err => colog.error(err) );
}

function getCollection(db, coll)
{
  return mongoClient.db(db).collection(coll);
}

function objectId(stringId)
{
  return new BSON.ObjectId(stringId);
}

module.exports.name = name;
module.exports.stitchClient = stitchClient;
module.exports.mongoClient = mongoClient;
module.exports.login = login;
module.exports.getCollection = getCollection;
module.exports.objectId = objectId;
module.exports.fn = require('./stitch_functions');