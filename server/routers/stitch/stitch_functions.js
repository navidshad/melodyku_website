
async function getById(dbname, collectionName, id)
{
    let stitchClient = global.services.stitch.stitchClient;
    return stitchClient.callFunction("getById", [dbname, collectionName, id]);
}

module.exports = {
    getById,
}