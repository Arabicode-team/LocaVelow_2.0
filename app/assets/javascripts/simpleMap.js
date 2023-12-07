"use strict";

const CONFIGURATION = {
  "mapOptions": {"center": {"lat":48.8566,"lng":2.3522}, "zoom": 15},
};

function initSimpleMap() {
  const {Map, Marker} = google.maps;

  const mapElement = document.getElementById('gmp-map');
  const lat = parseFloat(mapElement.getAttribute('data-latitude'));
  const lng = parseFloat(mapElement.getAttribute('data-longitude'));

  if (!isNaN(lat) && !isNaN(lng)) {
    const position = {lat: lat, lng: lng};
    const map = new Map(mapElement, Object.assign({}, CONFIGURATION.mapOptions, {center: position}));
    new Marker({position: position, map: map});
  }
}
