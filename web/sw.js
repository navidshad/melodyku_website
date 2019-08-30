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

workbox.precaching.precacheAndRoute([
  {
    "url": "assets/css/fontiran.css",
    "revision": "88da660788884c70665db7947085a73d"
  },
  {
    "url": "assets/css/w3.css",
    "revision": "fcb3cc3f981ba3e4d9a68f1a3520370a"
  },
  {
    "url": "assets/imgs/fake_slider.png",
    "revision": "e1e4a08563dc3874325d4f31d8428522"
  },
  {
    "url": "assets/imgs/footer_back01_raw.jpg",
    "revision": "0dccfc23171e84dd9bcdea0c91471d4b"
  },
  {
    "url": "assets/imgs/footer_back01.jpg",
    "revision": "13408c50d8a42d419aa7d3094294b743"
  },
  {
    "url": "assets/imgs/footer_back02.jpg",
    "revision": "bd402f7ebcba975607d8a2da10e0dadd"
  },
  {
    "url": "assets/imgs/icons/albums.png",
    "revision": "965bab9c43ebf330c9f1084d45da7797"
  },
  {
    "url": "assets/imgs/icons/arrow_left.png",
    "revision": "139ffbf171757bbac1616b975a18d9df"
  },
  {
    "url": "assets/imgs/icons/artists.png",
    "revision": "0119bb69fa8f5bb75753f9f2ce982ae5"
  },
  {
    "url": "assets/imgs/icons/create_list.png",
    "revision": "d9e7bedf460dbf7ebd2575ea93bf8773"
  },
  {
    "url": "assets/imgs/icons/downloads.png",
    "revision": "cb04d0036130647a8fa4fba85b54c667"
  },
  {
    "url": "assets/imgs/icons/favorites.png",
    "revision": "e496f0b89627349caf12a0b5b87a1877"
  },
  {
    "url": "assets/imgs/icons/free_tacks.png",
    "revision": "3a213701228e6b065c576c607d11059b"
  },
  {
    "url": "assets/imgs/icons/genres.png",
    "revision": "da779c766f03d0c9024829352fbb59c1"
  },
  {
    "url": "assets/imgs/icons/history.png",
    "revision": "0edb343dbb81cc052b8447b1e9d6a314"
  },
  {
    "url": "assets/imgs/icons/home.png",
    "revision": "6043c530fc6fcb432a13cd41a4b4fb12"
  },
  {
    "url": "assets/imgs/icons/isPlaying.png",
    "revision": "fde236a07955e26852c74f7114d90b4e"
  },
  {
    "url": "assets/imgs/icons/liked.png",
    "revision": "fa591ca5c840849da797de78e084c179"
  },
  {
    "url": "assets/imgs/icons/more.png",
    "revision": "05a12a115e616ee848bd7c2ed4ded55b"
  },
  {
    "url": "assets/imgs/icons/play.png",
    "revision": "0b98aeb911cefd8c49a925222bbb8d8a"
  },
  {
    "url": "assets/imgs/icons/playlists.png",
    "revision": "525d48a4fba78955208cd7a951cd0994"
  },
  {
    "url": "assets/imgs/icons/Purchased.png",
    "revision": "1f93cc144713627bb7e708ab5c188e86"
  },
  {
    "url": "assets/imgs/icons/stations.png",
    "revision": "4fbac80238693d17b53c6897c98bb123"
  },
  {
    "url": "assets/imgs/icons/top_tracks.png",
    "revision": "8b062521224519599b1a6a93e2b7d07a"
  },
  {
    "url": "assets/imgs/logo_small.png",
    "revision": "6af2c73435d874a1f39ca4fade31a69f"
  },
  {
    "url": "assets/imgs/logo.png",
    "revision": "2e99367b0b3c0a64fda98094d561e4e7"
  },
  {
    "url": "assets/imgs/patterns/01.jpg",
    "revision": "dcef2f5e7aeb6cbfb6de5c40454f9cdd"
  },
  {
    "url": "assets/imgs/patterns/02.jpg",
    "revision": "ef7587693357102fbeee55bb619be7a3"
  },
  {
    "url": "assets/imgs/patterns/03.jpg",
    "revision": "ac76fc7a388014bdf48365526a6841aa"
  },
  {
    "url": "assets/imgs/patterns/04.jpg",
    "revision": "385a73ce5cb1d553e98480b1bf901afa"
  },
  {
    "url": "assets/imgs/patterns/05.jpg",
    "revision": "b33b75f3f50320c9ac8b7c7c6ece3c8f"
  },
  {
    "url": "assets/imgs/patterns/06.jpg",
    "revision": "43cd0d998f77673f1bd621d79b1290f0"
  },
  {
    "url": "assets/imgs/patterns/07.jpg",
    "revision": "cd1d0724047d85de2109811d6f259106"
  },
  {
    "url": "assets/imgs/patterns/08.jpg",
    "revision": "fa946036518b399e03c6607633ef6bf7"
  },
  {
    "url": "assets/imgs/patterns/09.jpg",
    "revision": "4dde117f83a5defb2d19b557d28901ec"
  },
  {
    "url": "assets/imgs/patterns/10.png",
    "revision": "c83b84dad8f9d209f9a7d0ff50404aab"
  },
  {
    "url": "assets/imgs/playerbar_back.jpg",
    "revision": "6f861c35e66c2ef18d6459859ffa8c97"
  },
  {
    "url": "assets/js/install.js",
    "revision": "06b728bd9720d19191ad2249561f4ec2"
  },
  {
    "url": "assets/js/sw_idb.js",
    "revision": "ec1be29f8df13c96df401ad762ba6cfd"
  },
  {
    "url": "assets/js/sw_installation.js",
    "revision": "231bc57c3663906b9ac458e1a8a0cbe0"
  },
  {
    "url": "assets/js/sw_message.js",
    "revision": "205bb43bcd924fa5c23b43e4f9b2909a"
  },
  {
    "url": "assets/js/sw_strategies.js",
    "revision": "c498741cdff3dd6d81fe39d4f44f0c70"
  },
  {
    "url": "assets/svg/equalizer01.svg",
    "revision": "f824b40d3aeb2b1190321c8fd68cca34"
  },
  {
    "url": "assets/svg/equalizer02.svg",
    "revision": "29c19a651c6f9c37004ac012a40f3d7b"
  },
  {
    "url": "assets/svg/icon_avatar.svg",
    "revision": "a509c0eb2494fb8d896d591a4007084f"
  },
  {
    "url": "assets/svg/icon_border_arrow_up.svg",
    "revision": "566c21fee7eab6b386fcff7c984fd5e1"
  },
  {
    "url": "assets/svg/icon_call.svg",
    "revision": "5db622b536c5b118b32152b39022dc9a"
  },
  {
    "url": "assets/svg/icon_checked.svg",
    "revision": "3aa1125270e78b5f7f5337d9112de805"
  },
  {
    "url": "assets/svg/icon_close.svg",
    "revision": "8dd103abb6a4054171677769a0fe74ea"
  },
  {
    "url": "assets/svg/icon_cover_play.svg",
    "revision": "21dbe175326353b4d6ba34470f772d04"
  },
  {
    "url": "assets/svg/icon_email.svg",
    "revision": "e170a1eb7757be0421e2fc7dcf6dd67e"
  },
  {
    "url": "assets/svg/icon_gmail.svg",
    "revision": "499326e5d821932d93f2abf90fddd39f"
  },
  {
    "url": "assets/svg/icon_instagram.svg",
    "revision": "1b3d3685fa8e06431bcec7611a96bbe3"
  },
  {
    "url": "assets/svg/icon_link_rounded.svg",
    "revision": "c8b00a195977b3047618746c1a38decb"
  },
  {
    "url": "assets/svg/icon_list.svg",
    "revision": "7e72401c5d2506091a1f2d2526809b13"
  },
  {
    "url": "assets/svg/icon_lock.svg",
    "revision": "feeb03d5721ff91d2bed16ca759a654a"
  },
  {
    "url": "assets/svg/icon_menu.svg",
    "revision": "cc7d1395ebd29af82a001ce26ec49b5f"
  },
  {
    "url": "assets/svg/icon_next_selected.svg",
    "revision": "132613820bd4c9b0314fc93b56862478"
  },
  {
    "url": "assets/svg/icon_next.svg",
    "revision": "e60fafeb6451d9771ab68131a9e53529"
  },
  {
    "url": "assets/svg/icon_pause.svg",
    "revision": "495492789d6451b28db33c26bbf16bfc"
  },
  {
    "url": "assets/svg/icon_play.svg",
    "revision": "1d93092468eefc2db97357f7bdbffd76"
  },
  {
    "url": "assets/svg/icon_repeat_selected.svg",
    "revision": "37d22cce6f048f4ca98d1f99f5096908"
  },
  {
    "url": "assets/svg/icon_repeat.svg",
    "revision": "b1c7c92b542343b57b6e9955ee87ea7b"
  },
  {
    "url": "assets/svg/icon_right-arrow.svg",
    "revision": "b60dd0d0b112d207bf8f0961be438be2"
  },
  {
    "url": "assets/svg/icon_search.svg",
    "revision": "6917dffec7fc6d3272b5db047c70d394"
  },
  {
    "url": "assets/svg/icon_shuffle_selected.svg",
    "revision": "10c32c2a2c98c98454849bc61884c5ca"
  },
  {
    "url": "assets/svg/icon_shuffle.svg",
    "revision": "806df27aeed91ac49c5434f4827b28ca"
  },
  {
    "url": "assets/svg/icon_speaker_mute.svg",
    "revision": "ac3ff09224016afea615f53e0ca55e76"
  },
  {
    "url": "assets/svg/icon_speaker.svg",
    "revision": "7da7d4931c8baefacd2e1bf4c8dc8f22"
  },
  {
    "url": "assets/svg/icon_telegram.svg",
    "revision": "22e8952dacbaa536985e34b4abe2c493"
  },
  {
    "url": "assets/svg/icon_translate.svg",
    "revision": "de6415f3c6b3730cffdb24320884f22a"
  },
  {
    "url": "assets/svg/icon_user_m.svg",
    "revision": "f6df7c65f528ee6c295e00f83816ca27"
  },
  {
    "url": "assets/svg/icon_user.svg",
    "revision": "6ad9286094cb5f7ddfa1e20e0af6af8f"
  },
  {
    "url": "assets/svg/icon_warning.svg",
    "revision": "357ea27abee6d5bf8d4525b292dfa111"
  },
  {
    "url": "assets/svg/loading_cycle.svg",
    "revision": "45e3cd710f0072fe82b7037bfe037360"
  },
  {
    "url": "assets/svg/loading_ellipsis.svg",
    "revision": "5e0f346f7205687c28473f3130ce925f"
  },
  {
    "url": "assets/svg/loading.svg",
    "revision": "b0693962a9d5d90123f315bbf517ac5d"
  },
  {
    "url": "assets/thirdparty/filepond/filepond-plugin-file-metadata.js",
    "revision": "b27b5498b67ac1d3af2eff4243398447"
  },
  {
    "url": "assets/thirdparty/filepond/filepond.min.css",
    "revision": "d4790019d7cdabb03b42993e29bd1500"
  },
  {
    "url": "assets/thirdparty/filepond/filepond.min.js",
    "revision": "f1fb3e82a6d410144462f9b831cd99a1"
  },
  {
    "url": "assets/thirdparty/swiper/swiper.min.css",
    "revision": "9097e7972b059ecae0f5bb78a0186f71"
  },
  {
    "url": "assets/thirdparty/swiper/swiper.min.js",
    "revision": "53fc0155c6c3cb55f34b749325ebb370"
  },
  {
    "url": "favicon.png",
    "revision": "6e6157506f1989504f7c0bf9f7fe498d"
  },
  {
    "url": "images/icons/icon-128x128.png",
    "revision": "899fe68eb29a43bce47c4d01a3abe395"
  },
  {
    "url": "images/icons/icon-144x144.png",
    "revision": "56ffef7b7d8eb5b5d565900b7ea3678d"
  },
  {
    "url": "images/icons/icon-152x152.png",
    "revision": "b2d126171dc440f4c099fe7809b00d40"
  },
  {
    "url": "images/icons/icon-192x192.png",
    "revision": "4f11d2f6c15859697313338328a48782"
  },
  {
    "url": "images/icons/icon-384x384.png",
    "revision": "e3d9fbfc34422eb32999f5014596f257"
  },
  {
    "url": "images/icons/icon-512x512.png",
    "revision": "e3d9fbfc34422eb32999f5014596f257"
  },
  {
    "url": "images/icons/icon-72x72.png",
    "revision": "24b26f50a4e3c995d5e7a9a2d9bb1e24"
  },
  {
    "url": "images/icons/icon-96x96.png",
    "revision": "7cca8b4603d7c3e731086fb6db465039"
  },
  {
    "url": "index.html",
    "revision": "4904e3995b41ff2cfa5c40d2f32d43f6"
  },
  {
    "url": "manifest.json",
    "revision": "e3280431c920355923a4c79e605bd2bc"
  },
  {
    "url": "offline.html",
    "revision": "3cc6a78968b55a0613836c00076875f4"
  },
  {
    "url": "styles.css",
    "revision": "9890394c13c4c194570985de95b7f6d3"
  },
  {
    "url": "sw_build.js",
    "revision": "cf67dc66842fca8ebe553a935151627d"
  },
  {
    "url": "version.json",
    "revision": "07f6da193fd317f21d7d562e817a0fff"
  },
  {
    "url": "workbox_build.js",
    "revision": "d405547f9373e190988a93581d88d9ff"
  }
]);