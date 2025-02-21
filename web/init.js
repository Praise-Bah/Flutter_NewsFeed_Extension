window.addEventListener('load', function(ev) {
  const loading = document.querySelector('.loading');
  const targetEl = document.querySelector("#flutter_target");

  _flutter.loader.loadEntrypoint({
    onEntrypointLoaded: async function(engineInitializer) {
      loading.textContent = "Initializing engine...";
      let appRunner = await engineInitializer.initializeEngine({
        hostElement: targetEl,
        assetBase: './'
      });
      loading.textContent = "Running app...";
      await appRunner.runApp();
    }
  }).catch(function(error) {
    loading.textContent = "Error: " + error;
    console.error('Failed to initialize Flutter app:', error);
  });
});
