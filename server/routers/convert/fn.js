let tools = require('modular-rest-toolkit');
const mm = require('music-metadata');
const fs = require('fs');
const path = require('path');

async function getlist(total, page, bitrate)
{
    let songColl = global.services.stitch.getCollection('media', 'song');
    let mainpipeLine = [ 
        { 
            "$match" : {
                "versions.bitrate" : bitrate
            }
        },
    ];

    let countPipeLine = mainpipeLine.concat([
        { $count: 'count' }
    ]);

    var countAggregateResult = await songColl.aggregate(countPipeLine).asArray().then();
    let count = countAggregateResult[0]['count'];

    let perPage = total;
    let navigator = tools.createNavigator(count, perPage, page);

    let pagePipeLine = mainpipeLine.concat([
        { 
            "$skip" : navigator.from
        }, 
        { 
            "$limit" : perPage,
        },
        { 
            "$project" : {
                "_id" : {
                    "$toString" : "$_id"
                }, 
                "title" : "$title", 
                "album" : "$album", 
                "artist" : "$artist"
            }
        }
    ]);

    return songColl.aggregate(pagePipeLine).asArray()
        .then((songs) => {
            return {'pages': navigator.pages, 'page': navigator.page, 'list': songs};
        });
}

function Command(command)
{
    var cp = require('child_process');
    //var cm = `"${Path}" ${command}`;
    var cm = `ffmpeg ${command}`;

    return new Promise((resolve, reject) =>
    {
        cp.exec(cm, (err, stdout) =>
        {
            if(err) reject(err);
            else resolve(stdout);
        })
    });
}

function addNewVersion(versions, baseDetail, presetTitle)
{
    baseDetail.title = presetTitle;

    var addedAlready = false;
    var index = null;

    versions.forEach((element, i) => 
    {
        if((element.title || '') === presetTitle) {
            addedAlready = true;
            index = i;
        }
    });

    //update
    if(addedAlready)
        versions[index] = baseDetail;
    //add
    else versions.push(baseDetail);

    return versions;
}

function uploadToFTP(song, preset, filePath)
{
    let ftp = global.services.ftp;

    return new Promise( async (done, reject) => 
    {
        // create directories
        let dir = `${global.config.ftp_convert_dir}/${song.artistId}`;
        await ftp.createSubdir(dir.split('/'))
            .catch(e => reject(`could not create ${dir} | ${e}`));

        // upload to ftp
        let title = `${song._id} ${preset.title}.${preset.type}`;
        let destPath = path.join(dir, title);
        
        await ftp.put(filePath, destPath)
            .catch(e => reject(`could not create ${destPath} | ${e}`));

        done();
    });
}

async function getFileDetail(filePath)
{
    let stats = fs.statSync(filePath);
    let fileSizeInBytes = stats.size;
    let buffer = fs.readFileSync(filePath);

    return await mm.parseBuffer(buffer, 'audio/mpeg', { duration: true, fileSize: fileSizeInBytes })
    .then( function (metadata) 
    {
        let detail = {};
        detail.duration = metadata.format['duration'];
        detail.bitrate = metadata.format['bitrate'];
        detail.size = fileSizeInBytes;
        return detail;
    });
}

function getlinkOfOrginalSong(song)
{
    let bitrate;

    song.versions.forEach(version => {
        if(version.isOriginal) bitrate = version.bitrate;
    })

    let link = `${global.config.domain_data}/${song.artistId}/${song.albumId}/${song._id} ${bitrate}.mp3`;
    return link;
}

function prepareToCovert(id, presetTitle)
{
    return new Promise( async (done, reject) => 
    {
        console.log('begine to convert', id);
        let presetColl = global.services.stitch.getCollection('cms', 'convert_preset');
        var preset = await presetColl.findOne({'title':presetTitle}).then();
        if(!preset) reject(`the preset ${presetTitle} dosent found.`);
    
        let song = await global.services.stitch.fn.getById('media', 'song', id)
            .catch(reject);

        if(!song) reject(`the ${id} doesn't found`);
        else await convert(song, preset).then(done).catch(reject);
    });
}

async function convert(song, preset)
{
    return new Promise( async (done, reject) => 
    {
        let id = song._id;

        // dowload from ftp ----
        console.log('download from ftp', id);
        let path = require('path');
        let link = getlinkOfOrginalSong(song);
    
        let temppath = global.config.temppath;
        let inputpath = path.join(temppath, `${id}.mp3`);
        // remove if exist
        //await tools.removeFile(inputpath).catch(reject);
        // dowload
        await tools.saveFromLink(link, inputpath).catch(reject);
    
        // convert ----
        let outpath = path.join(temppath, `${id} ${preset.title}.${preset.type}`);
    
        let command_ffmpeg = `${preset.input} "${inputpath}" ${preset.output} "${outpath}"`;
        await Command(command_ffmpeg).catch(reject);
        
        console.log('converted', id, outpath);

        // get file detail
        let versionBaseDetail = await getFileDetail(outpath).catch(reject);

        // validate detail
        let validated = tools.validateObject(versionBaseDetail, 'duration bitrate');
        if(!validated.isValid) reject('file detail is wrong: ' + validated.requires.toString());
    
        let newVersions = await addNewVersion(song.versions, versionBaseDetail, preset.title);

        //upload to ftp
        await uploadToFTP(song, preset, outpath).catch(reject);

        // update song
        let songColl = global.services.stitch.getCollection('media', 'song');
        let query = {'_id': song._id};
        let update = { $set: {'versions': newVersions} };
        await songColl.updateOne(query, update).then().catch(reject);
        
        done(song);

        //remove files
        tools.removeFile(inputpath);
        tools.removeFile(outpath);
    });
}

module.exports = {
    getlist, prepareToCovert,
}
