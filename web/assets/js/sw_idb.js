let dbVersion = 2;
/*
	an IndexedDB wrapper for using in Melodyku service worker
*/
function openDB(idb, name, version, onUpgradeNeeded)
{
	return new Promise((done, reject) =>
	{
		let openReq = idb.open(name, version);

		openReq.onupgradeneeded = onUpgradeNeeded;
		openReq.onsuccess  = done;
		openReq.onerror = reject;
	});
}

function getTransaction(db, storeList)
{
	return new Promise((done, reject) =>
	{
		let req = db.transaction([storeList], 'readwrite');
    	req.onsuccess = done(req);
    	req.onerror = reject;
	});
}

let upgradeFunction = 
{
	'request-catch': (event) => 
	{
		db = event.target.result;

		if (!db.objectStoreNames.contains('post'))
			objectStore = db.createObjectStore('post', { keyPath: '_id' });
	},
}

function sleep(after)
{
	return new Promise((done) => setTimeout(done, after));
}

class IDBAdapter
{
	constructor(dbName)
	{
		this.name = dbName;
		this.isConnected = false;
		this.connect();
	}

	async connect() 
	{
		console.log('sw == connecting to', this.name);
		
		await openDB(self.indexedDB, this.name, dbVersion, upgradeFunction[this.name])
			.then(req => 
			{
				this.db = req.target.result;
				this.isConnected = true;
			})
			.catch(console.error);
	};

	async waiteUnilConnected()
	{
		return new Promise( async (done) => 
		{
			do {
				if(this.isConnected) done();
				else await sleep(200);
			}	
			while(!this.isConnected);
		});
	}

	async add(store, doc)
	{
		return new Promise( async (done, reject) => 
		{
			await this.waiteUnilConnected();

			let req = this.db.transaction([store], 'readwrite')
				.objectStore(store)
	    		.add(doc);

	    	req.onsuccess = () => done();
	    	req.onerror = () => reject(req.error);
		});
	};

	async put(store, doc)
	{
		return new Promise( async (done, reject) => 
		{
			await this.waiteUnilConnected();

			let req = this.db.transaction([store], 'readwrite')
				.objectStore(store)
	    		.put(doc);

	    	req.onsuccess = () => done();
	    	req.onerror = () => reject(req.error);
		});
	};

	async get(store, key)
	{
		return new Promise( async (done, reject) => 
		{
			await this.waiteUnilConnected();

			let req = this.db.transaction([store], 'readwrite')
				.objectStore(store)
	    		.get(key);

	    	req.onsuccess = () => {
	    		done(req.result);
	    	};

	    	req.onerror = () => reject(req.error);
		});
	};
};

let IDB_request = new IDBAdapter('request-catch');
