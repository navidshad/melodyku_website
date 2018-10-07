/*eslint-disable semi, no-unused-params, no-undef, no-redeclare, no-extra-semi, no-shadow-global*/
var address = {
    panelHost : 'http://localhost:2001',
    host :  'http://localhost:2000',
    user :  '/user',
    archive:'/archive',
    search: '/search',
    convert:'/convert',
    select:'/select',
    letterReplacment:'/latterreplacment'
}

var post = function(path, data)
{
    var form = { 'url' : path, 'form': data};
    return new Promise((resolve, reject) => {
        global.fn.request.post( form, function(err, httpResponse, body)
            {
                if(err) reject(err);

                var pbody = null;
                try {
                    pbody = JSON.parse(body);
                } catch (error) {
                    console.log(error);
                    reject(error);
                }
                resolve(pbody);
            }
        );
    });
}

var del = function(path, data)
{
    var form = { 'url' : path, 'form': data };
    return new Promise((resolve, reject) => {
        global.fn.request.del( form, function(err, httpResponse, body)
            {
                if(err) reject(err);
                
                var pbody = null;
                try {
                    pbody = JSON.parse(body);
                } catch (error) {
                    console.log(error);
                    reject(error);
                }
                resolve(pbody);
            }
        );
    });
}

var get = function(path)
{
    return new Promise((resolve, reject) =>
    {
        global.fn.request(path, function(err, httpResponse, body)
            {
                var pbody = null;
                try {
                    pbody =JSON.parse(body);
                } catch (error) {
                    console.log(error);
                    reject(error);
                }
                resolve(pbody);
            }
        );
    });
}

//user ------------------------------------------------------
//check a media to see if it was liked or not
var checkmedia = async function(userid, favoritem, callback)
{
    var data = {'userid' : userid, 'item': favoritem}
    var path = address.host + address.user + '/favorite/check';

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}

//get user favorites
var getfavorites = async function(userid, type, total, page)
{
    var path = address.host + address.user + '/favorites';
    var data = {'userid':userid, 'type':type, 'total': total, 'page': page};

    var result = await post(path, data).then()
    .catch(e => { console.log(e) });
    return result;
}

//media -----------------------------------------------------
//create a media
var sendmedia = async function(detail)
{
    var path = address.host + address.archive;
    path += '/media';

    var result = await post(path, detail).then().catch(e => { console.log(e) });
    return result;
}
//get media by singer's name
var getmedia = async function(title, singer, userid=null, callback)
{
    var path = address.host + address.archive;
    path += '/media/name';
    var data = { 'title': title, 'singername': singer, 'userid': userid };

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//get media by id
var getmediabyid = async function(id, userid, callback=null)
{
    var path = address.host + address.archive;
    path += '/media/id';
    var data = {'id':id, 'userid':userid};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//get singer's all medias
var getmediasbysinger = async function(singer, total, page, callback)
{
    var path = address.host + address.archive;
    path += '/media/all';
    var data = { 'singername': singer, 'total': total, 'page':page };

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//updatemediabyid
var updatemediabyid = async function(detail, callback)
{
    var path = address.host + address.archive;
    path += '/media/update';

    var result = await post(path, detail).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//delete a media
var deletemedia = function(id, callback)
{
    var path = address.host + address.archive;
    path += '/media';
    global.fn.request.del({
    'url' : path,
    'form': {'id':id}
    },
    function(err, httpResponse, body){
        if(body && callback) callback(JSON.parse(body));
    });
}

//album and singer ------------------------------------------
//get all singers
var getsingers = async function(total, page, callback)
{
    var path = address.host + address.archive;
    path += '/singer/all/' + total + '/' + page;

    var result = await get(path).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//get singer's album
var getsinger = async function(name)
{
    var path = address.host + address.archive;
    path += '/singer';
    var data = { 'name': name };

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}
var updatesingerbyid = async function(detail, callback)
{
    var path = address.host + address.archive;
    path += '/singer/update';

    var result = await post(path, detail).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//get singer's albums
var getalbums = async function(singer, callback)
{
    var path = address.host + address.archive;
    path += '/album/all';
    var data = { 'singername': singer };

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result.albums);
    return result.albums;
}
//get singer's album
var getalbum = async function(name, singer, callback)
{
    var path = address.host + address.archive;
    path += '/album';
    var data = { 'name': name, 'singername': singer };

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result.album);
    return result.album;
}
//get singer's album by id
var getalbumbyid = async function(id, callback)
{
    var path = address.host + address.archive;
    path += '/album/id/' + id;

    var result = await get(path).then().catch(e => { console.log(e) });
    if(callback) callback(result.album);
    return result.album;
}
//update album by id
var updatealbumbyid = async function(detail, callback)
{
    var path = address.host + address.archive;
    path += '/album/update';

    var result = await post(path, detail).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//delete album
var deletealbum = function(id, callback)
{
    var path = address.host + address.archive;
    path += '/album';

    let data = {'id':id};

    global.fn.request.del({
    'url' : path,
    'form': data
    },
    function(err, httpResponse, body){
        if(body && callback) callback(JSON.parse(body));
    });
}

//playlist --------------------------------------------------
//create playlist
var sendplaylist = async function(detail, callback)
{
    var path = address.host + address.archive;
    path += '/playlist';

    var result = await post(path, detail).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}
//get playlists
var getplaylists = async function(callback)
{
    var path = address.host + address.archive;
    path += '/playlist/all';

    var result = await get(path).then().catch(e => { console.log(e) });
    if(callback) callback(result.lists);
    return result.lists;
}
//get playlist
var getplaylist = async function(name, callback)
{
    var path = address.host + address.archive;
    path += '/playlist/get';
    var data = {'name' : name};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result.playlist);
    return result.playlist;
}
//get playlist by id
var getplaylistByid = async function(id, callback)
{
    var path = address.host + address.archive;
    path += '/playlist/id';
    var data = {'id' : id};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    if(callback) callback(result.playlist);
    return result.playlist;
}
//edit playlist
var editplaylist = function(detail, callback)
{
    var path = address.host + address.archive;
    path += '/playlist';
    global.fn.request.patch({
    'url' : path,
    'form': detail
    },
    function(err, httpResponse, body){
        if(body && callback) callback(JSON.parse(body));
        console.log('editPlay list', body);
    });
}
//remove playlist
var removeplaylist = function(id, callback)
{
    var path = address.host + address.archive;
    path += '/playlist';
    global.fn.request.del({
    'url' : path,
    'form': {'id':id}
    },
    function(err, httpResponse, body){
        if(body && callback) callback(JSON.parse(body));
    });
}

//search ----------------------------------------------------
var search = async function(word, callback)
{
    var path = address.host + address.search;
    var data = {'word': word};
    
    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}

//statistics
var getStatistics = async function(type, page, option={}, callback)
{
    var path = address.host;
    path += '/statistics';

    option.type = type;
    option.page = page;

    var result = await post(path, option).then().catch(e => { console.log(e) });
    if(callback) callback(result);
    return result;
}

// utility --------------------------------------------------
var removeitem = async function(data)
{
    var path = address.host + address.archive;
    path += '/item';

    var result = await del(path, data).then().catch(e => { console.log(e) });
    return result;
}
//get media by singer's name
var like = async function(userid, type, id)
{
    var path = address.host + address.archive;
    path += '/like';
    var data = { 'userid': userid, 'type': type, 'id':id };

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}
// get a media
var getMedia = async function(mode)
{
    var path = address.host + address.select;
    path += '/one';
    var data = { 'mode': mode};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}

// convert ---------------------------------------------------------------
//get  configs
var getConfigs = async function(id)
{
    var path = address.host + address.convert;
    path += '/getConfigs';

    var result = await get(path).then().catch(e => { console.log(e) });
    return result;
}

//create  config
var createConf = async function(config)
{
    var path = address.host + address.convert;
    path += '/createConf';

    var result = await post(path, config).then().catch(e => { console.log(e) });
    return result;
}

//delete  config
var removeConf = async function(id)
{
    var path = address.host + address.convert;
    path += '/removeConf';
    var data = {'id': id};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}

var getConvertList = async function(page, total, config)
{
    var path = address.host + address.convert;
    path += '/list';
    var data = {'page': page, 'total':total, 'config':config};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}

var convert = async function(id, config)
{
    var path = address.host + address.convert;
    path += '/convert';
    var data = {'id': id, 'config':config};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}

// reporting -------------------------------------------------------------
var reportActivity = async function(telegramid, type, detail, successful)
{
    var path = address.panelHost;
    path += '/dashboard/activity/report';

    var data = {};
    data.telegramid = telegramid;
    data.type = type;
    data.detail = detail;
    data.successful = successful;

    var result = await post(path, data).then().catch(e => { console.log(e) });
    console.log(result);
    return result;
}

// convert ---------------------------------------------------------------
//get letters
var getLetters = async function()
{
    var path = address.host + address.letterReplacment;

    var result = await get(path).then().catch(e => { console.log(e) });
    return result;
}

//create  letter
var createLetter = async function(letter)
{
    var path = address.host + address.letterReplacment;
    path += '/create';

    var result = await post(path, letter).then().catch(e => { console.log(e) });
    return result;
}

//update  letter
var updateLetter = async function(letter)
{
    var path = address.host + address.letterReplacment;
    path += '/update';

    var result = await post(path, letter).then().catch(e => { console.log(e) });
    return result;
}

//delete  letter
var removeLetter = async function(id)
{
    var path = address.host + address.letterReplacment;
    path += '/remove';
    var data = {'id': id};

    var result = await post(path, data).then().catch(e => { console.log(e) });
    return result;
}

module.exports = 
{
    //archive
    sendmedia, sendplaylist, getmedia, getmediabyid, deletemedia, getmediasbysinger, updatemediabyid,
    getalbum, getalbumbyid, getalbums, getsingers, getsinger, updatesingerbyid, updatealbumbyid, deletealbum,
    getplaylists, getplaylist, getplaylistByid, editplaylist, removeplaylist,
    search, getStatistics,
	
    //utilities
    removeitem, like, getMedia,
	
    //convert
    getConfigs, createConf, removeConf, getConvertList, convert,
	
    //report
    reportActivity,
	
	//user
	checkmedia, getfavorites,
	
    //letterReplacment
    getLetters, createLetter, updateLetter, removeLetter,
 }
