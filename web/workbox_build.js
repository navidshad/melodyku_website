const workboxBuild = require('C:/Users/navid/AppData/Roaming/npm/node_modules/workbox-build/build/index.js');

// NOTE: This should be run *AFTER* all your assets are built
const buildSW = () => {
  // This will return a Promise
  return workboxBuild.injectManifest({
    swSrc: '/assets/js/sw.js',
    swDest: 'sw.js',
    globDirectory: 'build',
    globPatterns: [
      '**\/*.{json,js,css,html,png,jpg,svg,woff,woff2}',
    ]
  }).then(({count, size, warnings}) => {
    // Optionally, log any warnings and details.
    warnings.forEach(console.warn);
    console.log(`${count} files will be precached, totaling ${size} bytes.`);
  });
}

buildSW();