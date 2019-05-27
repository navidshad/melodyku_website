function getCollction(type)
{
  let coll;
  
  if(type == 'user') coll = global.services.stitch.getCollection('user', 'detail');
  else coll = global.services.stitch.getCollection('media', type);
    
  return coll;
}

function updateTimeStamp(type, id, time)
{
  let objectid = global.services.stitch.objectId(id);
  let coll = getCollction(type);
  
  let update = { $set: { imgStamp: time}};
  
  let query = {_id: objectid};
  if(type == 'user') query = {refId: id};
    
  // update related items in other collection
  if(type == 'artist')
    {
        getCollction('album').updateMany({artistId: id}, { $set: { imgStamp_artist: time} }).then();
        getCollction('song').updateMany({artistId: id}, { $set: { imgStamp_artist: time} }).then();
    }
  else if(type == 'album')
    {
        getCollction('song').updateMany({albumId: id}, { $set: { imgStamp_album: time} }).then();
    }
  
  return coll.updateOne(query, update)
    .then((r) => { return time; });
}

function createFilePath(dir, id, time)
{
  return `${dir}/${id}-${time}.jpg`;
}

function removeOldImage(type, id, dir)
{
  let objectid = global.services.stitch.objectId(id);
  let coll = getCollction(type);
  
  let query = {_id: objectid};
  if(type == 'user') query = {refId: id};
  
  return coll.find(query).first()
    .then(async doc => 
    {
      let oldTime = doc.imgStamp;
      let destPath = createFilePath(dir, id, oldTime);
      return global.services.ftp.delete(destPath).then();
    });
}

function uploadPhoto(type, id, file)
{
    let ftp = global.services.ftp;
    let rootDir = global.config.ftp_photo_dir;

    return new Promise( async (done, reject) => 
    {
        // create directory
        let dir = `${rootDir}/${type}`;
        await ftp.createSubdir(dir.split('/')).catch(reject);
      
        // delete if exists
        await removeOldImage(type, id, dir).catch(reject);
      
        let time = new Date().getTime();
        await updateTimeStamp(type, id, time).catch(reject);
        let destPath = createFilePath(dir, id, time);

        // upload file
        ftp.put(file.path, destPath).then(done).catch(reject);
    });
}

function removePhoto(type, id)
{
    let ftp = global.services.ftp;
    let rootDir = global.config.ftp_photo_dir;
  
    return new Promise( async (done, reject) => 
    {
        // directory
        let dir = `${rootDir}/${type}`;
        // delete if exists
        await removeOldImage(type, id, dir).catch(reject);
        // update timeStamp to be ''
        await updateTimeStamp(type, id, null).then(done).catch(reject);
    });
}

module.exports = {
    uploadPhoto,
    removePhoto
}