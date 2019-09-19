self.addEventListener('message', function(event)
{
    console.log("SW Received Message: " + event.data);

    if (event.data && event.data.action === 'PROMPT_UPDATE_MESSAGE')
    	send_message_to_all_clients({ action: 'PROMPT_UPDATE_MESSAGE' });

    // using this for remove a downloaded Song
    else if(event.data.action == 'REMOVE_CACHE') 
    	removeCache(event.data);
});

function removeCache(data)
{
	let {cacheName, url} = data;

	return caches.open(cacheName)
		.then((cache) => cache.delete(url));
}

function send_message_to_all_clients(msg)
{
    clients.matchAll({includeUncontrolled: true})
    .then(list => {
        list.forEach(client => {
            client.postMessage(msg);
        })
    });
}