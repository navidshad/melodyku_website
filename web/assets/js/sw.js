/*
  Melodyku service worker
*/
importScripts('https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js');
importScripts('/assets/js/sw_message.js');
importScripts('/assets/js/sw_idb.js');
importScripts('/assets/js/sw_strategies.js');

let version = "0.6.8";

// Updating SW lifecycle to update the app after user triggered refresh
workbox.core.skipWaiting();
workbox.core.clientsClaim();

// catch content provider
workbox.routing.registerRoute(
  ({url, event}) => {
  	return isMatch(url, 
  	['aggregate', 'find', 'findOne'])
  },
  catchFirstPostRequest_bodyAsKey,
  'POST'
);

// catch auth requests
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, 
    ['loginAnonymous', 'varify/token', 'getPermission'])
  },
  catchFirstPostRequest_pathAsKey,
  'POST'
);

// catch defualt value for some apis
workbox.routing.registerRoute(
  ({url, event}) => {
  	let pathes = ['count'];
  	if(isMatch(url, pathes)) return {body:0};
  	else false;
  },
  defultBodyWhenOffline,
  'POST'
);

// response from network first
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, ['findOne']) 
  },
  networkFirstPostRequest_bodyAsKey,
  'POST'
);

// response from network first
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, ['/versions.js', '/sw.js']) 
  },
  new workbox.strategies.NetworkFirst()
);

// catch songs
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, ['/stream?ai']) 
  },
  catchFirstSongRequest
);

workbox.precaching.precacheAndRoute([]);