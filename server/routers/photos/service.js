function uploadPhotos(type, id, file)
{
    let ftp = global.services.ftp;
    let rootDir = global.config.ftp_photo_dir;

    return new Promise( async (done, reject) => 
    {
        // create directory
        let dir = `${rootDir}/${type}`;
        await ftp.createSubdir(dir).catch(reject);

        // upload file
        let destPath = `${dir}/${id}.jpg`;
        ftp.put(file).then(done).catch(reject);
    });
}

module.exports = {
    uploadPhotos
}