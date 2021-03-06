let path = require('path');
let wbModulePath = path.normalize('C:\\Users\\navid shad\\AppData\\Roaming\\npm\\node_modules\\workbox-build\\');
const workboxBuild = require(wbModulePath);

// NOTE: This should be run *AFTER* all your assets are built
const buildSW = () => {
  // This will return a Promise
  return workboxBuild.injectManifest({
    swSrc: './assets/js/sw.js',
    swDest: 'sw.js',
    globDirectory: './',
    globPatterns: [
      '**\/*.{png,jpg,svg,woff,woff2,html,css,js,json}',
    ]
  }).then(({count, size, warnings}) => {
    // Optionally, log any warnings and details.
    warnings.forEach(console.warn);
    console.log(`${count} files will be precached, totaling ${size} bytes.`);
  });
}

buildSW();