let tools = require('modular-rest-toolkit');
let registeredSongs = {};

function registerSoungId(userId, header)
{
    let stamp = new Date().getTime();
    let jsonHeader = JSON.stringify(header);
    registeredSongs[userId] = jsonHeader;

    console.log('user registered:', stamp);
    return stamp;
}

function hasAccess(userId, header)
{
    let key = false;

    let registeredStamp = registeredSongs[userId];
    let jsonHeader = JSON.stringify(header);

    if(registeredStamp == jsonHeader)
    {
        key = true;
        console.log('asked stamp', stamp);

        //delete registeredSongs[userId];
    }

    return key;
}

module.exports = {
    registerSoungId, hasAccess,
}
