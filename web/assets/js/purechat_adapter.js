let purechatApiIsReady = false;

purechatApi.on('chatbox:ready', function () { 
     purechatApiIsReady = true;
}); 

function waite(ms)
{
	return new Promise((done) => setTimeout(done, ms));
}

function getPureChatApi()
{
	return new Promise( async (done) => 
	{
		do{ await waite(100); }
		while(!purechatApiIsReady)

		done(purechatApi);
	});
}