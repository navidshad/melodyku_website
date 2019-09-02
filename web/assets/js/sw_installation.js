import {Workbox} from 'https://melodyku.ir/workbox-window/build/workbox-window.prod.mjs';

if ('serviceWorker' in navigator) 
{
	const wb = new Workbox('/sw.js');

	wb.addEventListener('waiting', (event) => 
	{
	 	// let confirmation = window.confirm('Melodyku has been updated, are you ready for reload this page?');
   		// if(confirmation) window.location.reload();
	});

	wb.addEventListener('activated', (event) => 
    {
    	// let confirmation = window.confirm('Melodyku has been updated, do you ready for reload this page?');
    	// if(confirmation) window.location.reload();

    	window.location.reload();
    });

	wb.register();
}