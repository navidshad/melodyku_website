/*
	coustom strategies of melodyku service worker
*/

function isMatch(url, arr)
{
	let key = false;
	
	arr.forEach(str => {
		if(url.href.includes(str)) {
			key = true;
			//console.log('.sw matched', url.href)
		}
	});

	return key;
}

async function catchFirstPostRequest_bodyAsKey({url, event})
{
	let request = event.request.clone();

	let body = await request.json();
	let id = `${url.pathname}-${JSON.stringify(body)}`;

	let serializeResponse = async function (response) 
	{
	  let serializedHeaders = {};
	  for (var entry of response.headers.entries()) {
	    serializedHeaders[entry[0]] = entry[1];
	  }
	  let serialized = {
	    headers: serializedHeaders,
	    status: response.status,
	    statusText: response.statusText
	  };

	  serialized.body = await response.json();
	  return serialized;
	}

	storeResponse = async function (resid, res)
	{
		let doc = await serializeResponse(res);
		doc['_id'] = resid;
    
    	return IDB_request.put('post', doc);
	}

	getResponse = function (resid)
	{
		//return idbKeyval
		return IDB_request.get('post', resid)
		.then((doc) =>
		{
			if(!doc) return null;
			else return new Response(JSON.stringify(doc.body), doc);
		})
	}

	return getResponse(id)
		.then((stored) => 
		{
			// not cached
			if(!stored) {
				throw('not catched');
				return;
			}

			// store updated response
			fetch(event.request)
				.then((res) => storeResponse(id, res))
				//.catch(console.log);

			return stored;
		})
		.catch(async e => {
			let response = await fetch(event.request);
			storeResponse(id, response.clone());
			return response;
		});

	//return fetch(event.request);
}

async function catchFirstPostRequest_pathAsKey({url, event})
{
	let request = event.request.clone();

	let body = await request.json();
	let id = url.pathname;

	let serializeResponse = async function (response) 
	{
	  let serializedHeaders = {};
	  for (var entry of response.headers.entries()) {
	    serializedHeaders[entry[0]] = entry[1];
	  }
	  let serialized = {
	    headers: serializedHeaders,
	    status: response.status,
	    statusText: response.statusText
	  };

	  serialized.body = await response.json();
	  return serialized;
	}

	storeResponse = async function (resid, res)
	{
		let doc = await serializeResponse(res);
		doc['_id'] = resid;
    
    	return IDB_request.put('post', doc);
	}

	getResponse = function (resid)
	{
		//return idbKeyval
		return IDB_request.get('post', resid)
		.then((doc) =>
		{
			console.log('sw == getResponse typeof doc', typeof doc);
			
			if(!doc) return null;
			else return new Response(JSON.stringify(doc.body), doc);
		})
	}

	return getResponse(id)
		.then((stored) => 
		{
			// not cached
			if(!stored) {
				throw('not catched');
				return;
			}

			// store updated response
			fetch(event.request)
				.then((res) => storeResponse(id, res))
				//.catch(console.log);

			return stored;
		})
		.catch(async e => {
			let response = await fetch(event.request);
			storeResponse(id, response.clone());
			return response;
		});

	//return fetch(event.request);
}

async function networkFirstPostRequest_bodyAsKey({url, event})
{
	let request = event.request.clone();

	let body = await request.json();
	let id = `${url.pathname}-${JSON.stringify(body)}`;

	let serializeResponse = async function (response) 
	{
	  let serializedHeaders = {};

	  for (var entry of response.headers.entries()) {
	    serializedHeaders[entry[0]] = entry[1];
	  }
    
	  let serialized = {
	    headers: serializedHeaders,
	    status: response.status,
	    statusText: response.statusText
	  };

	  serialized.body = await response.json();
	  return serialized;
	}

	storeResponse = async function (resid, res)
	{
		let doc = await serializeResponse(res);
		doc['_id'] = resid;
		return idbKeyval.set(resid, doc);
	}

	getResponse = function (resid)
	{
		return idbKeyval.get(resid)
		.then((doc) =>
		{
			if(!doc) return null;
			else return new Response(JSON.stringify(doc.body), doc);
		})
	}

	return fetch(event.request)
		.then((networkRes) => 
		{
			// not cached
			if(!networkRes) {
				throw('not respond');
				return;
			}

			// store updated response
			storeResponse(id, networkRes.clone());

			return networkRes;
		})
		.catch(async e => getResponse(id));
}

async function defultBodyWhenOffline({url, event, params})
{
	return fetch(event.request)
		.catch(e => 
		{
			let baseRes = {
				status: 200,
			};

			return new Response(params.body, baseRes);
		});
}

async function catchFirstSongRequest({url, event, params})
{
	let songid = url.searchParams.get('si');
	let CACHE_NAME = "user_downloads";

	// create new request
	let rOP = { 
		'headers': {'requester': 'melodyku client'},
	};

	let req = new Request(url.href, rOP);

	let responsFromServer = () => fetch(req);

	let catchTheSong = (response) => 
	{
		//console.log('sw == store song', response);
		return caches.open(CACHE_NAME)
			.then((cache) => cache.put(req.clone(), response));
	}

	let getCache = () => 
	{
		return caches.open(CACHE_NAME)
			.then((cache) => cache.match(url.href));
	}

	return IDB_media.get('song', songid)
	.then((song) =>
	{
		if(!song) throw('song dosent found');
		
		// get catch
		return getCache()
		.then(match => 
		{
			if(!match) throw('matched not found');
			else return match;
		})
		// download => store => return to browser
		.catch((e) => 
		{
			console.log(e);
			//console.log('download => store => return to browser');
			return fetch(req)
			// store and
			.then(res => 
			{
				catchTheSong(res.clone());
				return res;
			});
		});
	})
	// response from server if is not in the download table
	.catch((e) => {
		console.error('response from server if song is not in the download caches', e);
		return responsFromServer();
	});
}