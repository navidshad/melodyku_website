/*
  Melodyku service worker
*/
importScripts('https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js');
importScripts('/assets/js/sw_message.js');
importScripts('/assets/js/sw_idb.js');
importScripts('/assets/js/sw_strategies.js');

// Force production builds
workbox.setConfig({ debug: false });

// Updating SW lifecycle to update the app after user triggered refresh
workbox.core.skipWaiting();
workbox.core.clientsClaim();

// activate offline analitic tracking
workbox.googleAnalytics.initialize({
  parameterOverrides: {
    cd1: 'offline',
  },
});

// install event
// self.addEventListener('install', (event) => 
// {
//   // send message to show Page Refresh Confirmation popup
//   send_message_to_all_clients({ action: 'PROMPT_UPDATE_MESSAGE' });
// });

/* remove caches */
let removingList = [
  'user_downloads'
]

for (var i = 0; i < removingList.length; i++) {
  let name = removingList[i];
  caches.delete(name);
}
/* end remove caches */

// routing precaches
workbox.precaching.precacheAndRoute([]);

// catche scripts and css
workbox.routing.registerRoute(
  ({url, event}) => {
    return isMatch(url, 
    ['.json', '.js', '.css'])
  },
  new workbox.strategies.StaleWhileRevalidate()
);

// catche index.html
workbox.routing.registerRoute(
  ({event}) => event.request.destination === 'document',
  returnIndexFromPrecaches
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
