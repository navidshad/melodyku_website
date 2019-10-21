/*
	coustom strategies of melodyku service worker
*/
let patterns = [
	'/assets/imgs/patterns/01.jpg',
	'/assets/imgs/patterns/02.jpg',
	'/assets/imgs/patterns/03.jpg',
	'/assets/imgs/patterns/04.jpg',
	'/assets/imgs/patterns/05.jpg',
	'/assets/imgs/patterns/06.jpg',
	'/assets/imgs/patterns/07.jpg',
	'/assets/imgs/patterns/08.jpg',
	'/assets/imgs/patterns/09.jpg',
];

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

function isMatch(url, arr=[], except=[])
{
	let key = false;
	
	arr.forEach(str => {
		if(url.href.includes(str))
			key = true;
	});

	except.forEach(str => {
		if(url.href.includes(str))
			key = false;
	});

	return key;
}

function ignoreIfHasLivePropertyInHeader(request)
{
	return request.headers.get('live');
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
		if(!res.clone().ok) return;

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
		if(!res.clone().ok) return;

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
		if(!res.clone().ok) return;

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

async function networkFirstPostRequest_pathAsKey({url, event})
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
		if(!res.clone().ok) return;
		
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

async function returnPatternImageOn404({url, event, params})
{
	return fetch(event.request)
		.catch(async fe => {

			// retrive precached pattern
			const cache = await caches.open(workbox.core.cacheNames.precache);
			const response = await cache.match(
			  workbox.precaching.getCacheKeyForURL(patterns[getRandomInt(8)])
			);

			if(response) return response;
			return fe;
		});
}

async function returnIndexFromPrecaches({url, event})
{
	// retrive precached pattern
	// const cache = await caches.open(workbox.core.cacheNames.precache);
	// const response = await cache.match(
	//   workbox.precaching.getCacheKeyForURL('/index.html')
	// );

	return caches.match('/index.html')
		.then(matched => 
		{
			if(matched) return matched;
			else return fetch(event.request);
		})
}