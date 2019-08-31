/*
  Melodyku service worker
*/
importScripts('https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js');
importScripts('/assets/js/sw_message.js');
importScripts('/assets/js/sw_idb.js');
importScripts('/assets/js/sw_strategies.js');

// Updating SW lifecycle to update the app after user triggered refresh
workbox.core.skipWaiting();
workbox.core.clientsClaim();

// catche scripts
workbox.routing.registerRoute(
   /\.(?:js|json)$/,
  new workbox.strategies.StaleWhileRevalidate()
);

// catche index.html
workbox.routing.registerRoute(
  ({event}) => event.request.destination === 'document',
  new workbox.strategies.StaleWhileRevalidate()
);

// catche images
// workbox.routing.registerRoute(
//   /^https:\/\/data.melodyku.(?:ir|com)\/images\/.*.(?:jpg|jpeg)/,
//   new workbox.strategies.CacheFirst({
//     cacheName: 'images',
//     plugins: [
//       new workbox.expiration.Plugin({
//         maxEntries: 200,
//         maxAgeSeconds: 15 * 24 * 60 * 60, // 15 Days
//       }),
//     ],
//   })
// );

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
