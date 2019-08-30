console.log('hello messenger');
self.addEventListener('message', function(event)
{
    console.log("SW Received Message: " + event.data.action);

    if (event.data && event.data.type === 'SKIP_WAITING'){
    	console.log('being to skip waiting')
		//skipWaiting();
    }

    else if(event.data.action == 'REMOVE_CACHE') 
    	removeCache(event.data);
});

function removeCache(data)
{
	let {cacheName, url} = data;

	return caches.open(cacheName)
		.then((cache) => cache.delete(url));
}