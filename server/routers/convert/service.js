let converter = require('./converter');
let name = 'converter';
let io;
let isConverting = false;
let askToStop = false;
let tools = require('modular-rest-toolkit');

function initializConverterSockets(SocketClient)
{
    SocketClient.on('getConverterStatus', (msg) => {
    	console.log('ask to get getConverterStatus');
        SocketClient.emit('getConverterStatus', {'isConverting': isConverting});
    });

    SocketClient.on('convertAll', (presetTitle) =>
    	convertAll(presetTitle));

    SocketClient.on('stopConvert', (presetTitle) => askToStop = true);
}

function broadCaseReportToUsers(msg) {
	global.io.emit('onConvertReport', msg);
}

function broadCaseStatusToUsers(SocketClient, msg) {
	global.io.emit('getConverterStatus', {'isConverting': isConverting});
}

async function convertAll(presetTitle)
{
	if(isConverting) return;

	console.log('begin to convert');

	isConverting = true;
	askToStop = false;

	let songColl = global.services.stitch.getCollection('media', 'song');

	let query = { 'versions.title': { $ne: presetTitle } }
	let count = await songColl.count(query).then();

	broadCaseReportToUsers(`begin to convert ${count} songs to ${presetTitle}:`);

	for (let i=0; i < count; i++) 
	{
		let pipeLine = [
			{ $match: query},
			{ $sort: { title: 1} },
			{ $skip: i},
			{ $limit: 1},
		];

		let song = await songColl.aggregate(pipeLine).first()
			.catch(async e => { 
				console.log(e);
        broadCaseReportToUsers(`${i} get song error | ${e}`);
				await tools.sleep(1000);
				i--;
			});

		await converter.prepareToCovertBySong(song, presetTitle)
			.then(r => {
				broadCaseReportToUsers(`${i} ${presetTitle} | ${song.artist} | ${song.title}`);
			})
			.catch(async e => { 
				console.log(e); 
        broadCaseReportToUsers(`${i} get song error | ${e}`);
				await tools.sleep(1000);
				i--;
			});

		if(askToStop) {
			askToStop = false;
			isConverting = false;
			broadCaseStatusToUsers();
			break;
		}
	}

	isConverting = false;
	broadCaseReportToUsers(`all songs converted to ${presetTitle}`);
	broadCaseStatusToUsers();
}

module.exports = {
	name,
	initializConverterSockets,
    convertAll,
    converter,
}