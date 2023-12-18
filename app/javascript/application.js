import "@hotwired/turbo-rails";
import "./controllers";
import { initMap as initAutocompleteMap } from "./packs/autocompleteMap";
import { initIndexMap } from "./packs/indexMap";
import { initSimpleMap } from "./packs/simpleMap";
import { estimateCost } from "./packs/estimate_cost";

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

// Сбросить флаги инициализации при переходе на новую страницу
document.addEventListener('turbo:before-visit', function () {
  mapsInitialized = {
    autocomplete: false,
    index: false,
    simple: false
  };
});

