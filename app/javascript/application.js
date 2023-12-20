import "@hotwired/turbo-rails";
import "./controllers";
import { initMap as initAutocompleteMap } from "./packs/autocompleteMap";
import { initIndexMap } from "./packs/indexMap";
import { initSimpleMap } from "./packs/simpleMap";
import { estimateCost } from "./packs/estimate_cost";
import "./packs/backToTopBtn.js";

let mapsInitialized = {
  autocomplete: false,
  index: false,
  simple: false
};

function initMaps() {
  if (document.getElementById('location-input') && !mapsInitialized.autocomplete) {
    initAutocompleteMap();
    mapsInitialized.autocomplete = true;
  }
  if (document.getElementById('index-map') && !mapsInitialized.index) {
    initIndexMap();
    mapsInitialized.index = true;
  }
  if (document.getElementById('gmp-map') && !mapsInitialized.simple) {
    initSimpleMap();
    mapsInitialized.simple = true;
  }
}

function initConditionalScripts() {
  if (document.getElementById('rental_form')) {
    estimateCost();
  }
}

document.addEventListener('turbo:load', function () {
  initConditionalScripts();
  initMaps();
});

document.addEventListener('turbo:before-visit', function () {
  mapsInitialized = {
    autocomplete: false,
    index: false,
    simple: false
  };
});


function toggleFont() {
  const body = document.body;
  body.classList.toggle('opendyslexic-font');
}

document.addEventListener('turbo:load', function() {
  const toggleFontButton = document.getElementById('toggleFontButton');

  if (toggleFontButton) {
    toggleFontButton.classList.add('opendyslexic-font');
    toggleFontButton.addEventListener('click', toggleFont);
  }
});
