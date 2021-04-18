'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "7b017d13a7db31dc731a93f4fd6de5f6",
"/": "7b017d13a7db31dc731a93f4fd6de5f6",
"manifest.json": "e4de7556fbfebc598e1a24836d7153e4",
"main.dart.js": "da785b7afa57c5021fe082a95bb76d55",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/AssetManifest.json": "b26873e5c62cae561a276fa28ca15d43",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/NOTICES": "c74497f100043e52ee3027a6e27c1be3",
"assets/assets/loading.gif": "701d48511423a8230f7ed7acebddc71b",
"assets/assets/loading_music_node.gif": "5354660edb3012683a3484d9550edf32",
"assets/assets/loading_music_node_outOfOrder.gif": "4877495ae6ecf3527ff7a844b62eed2f",
"assets/assets/images/p2.jpg": "a48a55e873c291c765736b0498823dcd",
"assets/assets/images/p7.jpg": "8159053881181e9aac81d9d534d1133c",
"assets/assets/images/p1.jpg": "607561e3f12062a5beb71210a60b3b06",
"assets/assets/images/avatar.png": "6581550010a2037ec723b5ea5d915897",
"assets/assets/images/p5.jpg": "33c96df92a8d6f209d741599d9927642",
"assets/assets/images/p3.jpg": "1d39abd149fe0e5458e7dad8c3ea7fb6",
"assets/assets/images/maria_01.jpeg": "6c59d8cbbf1f8d280459a8dacac2a86a",
"assets/assets/images/p4.jpg": "f5d402844d31a252794475bf5297d66d",
"assets/assets/images/p6.jpg": "7ce5f9b103fe4f481b7aacd8ce81e36a",
"assets/assets/ezgif.com-gif-maker.gif": "bfa8669e48124f57e844fecf63c66bae",
"assets/assets/music/Jazzfunk.mp3": "6f978f0462c9c3043c194c347c165441",
"assets/assets/music/Latin.mp3": "ce3d81b300a1ead44acaa56005e8d7fb",
"assets/assets/music/Jazztronica.mp3": "304e7c94fb981c05e9be8299d13337d4",
"assets/assets/music/Freejazz.mp3": "cab17f6da9881767e1470891141928d0",
"assets/assets/music/Duckpond_Titelmusik.mp3": "f1bb54a7d47b08fb090fdaaf49e7c9c4",
"assets/assets/music_logo.png": "96d43a2af6c52fba643c7a8ab30ff567",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "bdacc44e21dae897c8171d6966b856fa"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
