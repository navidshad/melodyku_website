let tools = require('modular-rest-toolkit');
let registeredSongs = {};

function registerSoungId(userId)
{
    let stamp = new Date().getTime();
    registeredSongs[userId] = stamp;

    console.log('user registered:', stamp);
    return stamp;
}

function hasAccess(userId, stamp)
{
    let key = false;

    let registeredStamp = registeredSongs[userId];

    if(registeredStamp == stamp)
    {
        key = true;
        console.log('asked stamp', stamp);

        delete registeredSongs[userId];
    }

    return key;
}

module.exports = {
    registerSoungId, hasAccess,
}
