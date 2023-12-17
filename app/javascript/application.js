import "@hotwired/turbo-rails";
import "./controllers";
import { initMap as initAutocompleteMap } from "./packs/autocompleteMap";
import { initIndexMap } from "./packs/indexMap";
import { initSimpleMap } from "./packs/simpleMap";
import { estimateCost } from "./packs/estimate_cost";

function initMaps() {
  if (document.getElementById('location-input')) {
    initAutocompleteMap();
  }
  if (document.getElementById('index-map')) {
    initIndexMap();
  }
  if (document.getElementById('gmp-map')) {
    initSimpleMap();
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

window.initMaps = initMaps;
window.initConditionalScripts = initConditionalScripts;
