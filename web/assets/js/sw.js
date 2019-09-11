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

// activate offline analitic tracking
workbox.googleAnalytics.initialize({
  parameterOverrides: {
    cd1: 'offline',
  },
});

// catche scripts and css
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, 
    ['.js', '.json', '.css'])
  },
  new workbox.strategies.StaleWhileRevalidate()
);

// catche index.html
workbox.routing.registerRoute(
  ({event}) => event.request.destination === 'document',
  new workbox.strategies.StaleWhileRevalidate()
);

// catche images
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, 
    ['data.melodyku.ir/images', 'data.melodyku.com/images'])
  },
  returnPatternImageOn404
);

// catch content provider
workbox.routing.registerRoute(
  ({url, event}) => {
    if(ignoreIfHasLivePropertyInHeader(event.request))
      return false;
    else return isMatch(url, ['contentProvider'], ['count'])
  },
  catchFirstPostRequest_bodyAsKey,
  'POST'
);

// return defual body to count query
workbox.routing.registerRoute(
  ({url, event}) => {
    if(isMatch(url, ['count'])) return {body: 0};
    else return false;
  },
  defultBodyWhenOffline,
  'POST'
);

// network first sterategy for other MongoQuery
workbox.routing.registerRoute(
  ({url, event}) => isMatch(url, ['contentProvider']),
  networkFirstPostRequest_bodyAsKey,
  'POST'
);

// catch auth requests
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, 
    ['loginAnonymous', 'varify/token', 'getPermission'])
  },
  networkFirstPostRequest_pathAsKey,
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
