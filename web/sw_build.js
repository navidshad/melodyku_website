const workboxBuild = require('C:/Users/navid/AppData/Roaming/npm/node_modules/workbox-build');

// NOTE: This should be run *AFTER* all your assets are built
const buildSW = () => {
  // This will return a Promise
  return workboxBuild.injectManifest({
    swSrc: './assets/js/sw.js',
    swDest: 'sw.js',
    globDirectory: './',
    globPatterns: [
      '**\/*.{json,js,css,html,png,jpg,svg,}',
    ]
  }).then(({count, size, warnings}) => {
    // Optionally, log any warnings and details.
    warnings.forEach(console.warn);
    console.log(`${count} files will be precached, totaling ${size} bytes.`);
  });
}

buildSW();