import {Workbox} from 'https://melodyku.ir/workbox-window/build/workbox-window.prod.mjs';

if ('serviceWorker' in navigator) 
{
	const wb = new Workbox('/sw.js');

	wb.addEventListener('waiting', (event) => 
	{

	});

	wb.addEventListener('activated', (event) => 
    {
    	//window.location.reload();
    	wb.messageSW({action: 'PROMPT_UPDATE_MESSAGE'});
    });

	wb.register();
}
