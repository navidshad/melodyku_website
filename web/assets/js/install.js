'use strict';

let deferredInstallPrompt = null;
let isInstalled = true;

function getInstallStatus()
{
  return isInstalled;
}

// CODELAB: Add event listener for beforeinstallprompt event
window.addEventListener('beforeinstallprompt', saveBeforeInstallPromptEvent);
function saveBeforeInstallPromptEvent(evt) {
  // CODELAB: Add code to save event & show the install button.
  deferredInstallPrompt = evt;
  isInstalled = false;
}


function installPWA() {
  // CODELAB: Add code show install prompt & hide the install button.
  deferredInstallPrompt.prompt();
  isInstalled = true;
  
  // CODELAB: Log user response to prompt.
  deferredInstallPrompt.userChoice
    .then((choice) => {
      if (choice.outcome === 'accepted') {
        console.log('User accepted the A2HS prompt', choice);
      } else {
        console.log('User dismissed the A2HS prompt', choice);
      }
      deferredInstallPrompt = null;
    });
}

// CODELAB: Add event listener for appinstalled event
window.addEventListener('appinstalled', logAppInstalled);
function logAppInstalled(evt) {
  // CODELAB: Add code to log the event
  console.log('Weather App was installed.', evt);
}
