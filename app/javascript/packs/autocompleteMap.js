"use strict";

const CONFIGURATION = {
  "ctaTitle": "Checkout",
  "mapOptions": {
    "center": {
      "lat": 48.8566,
      "lng": 2.3522
    },
    "fullscreenControl": true,
    "mapTypeControl": false,
    "streetViewControl": true,
    "zoom": 11,
    "zoomControl": true,
    "maxZoom": 22,
    "mapId": ""
  },
  "capabilities": {
    "addressAutocompleteControl": true,
    "mapDisplayControl": true,
    "ctaControl": true
  }
};

const SHORT_NAME_ADDRESS_COMPONENT_TYPES = new Set(['street_number', 'administrative_area_level_1', 'postal_code']);

const ADDRESS_COMPONENT_TYPES_IN_FORM = [
  'location',
  'locality',
  'administrative_area_level_1',
  'postal_code',
  'country',
];

function getFormInputElement(componentType) {
  return document.getElementById(`${componentType}-input`);
}

function fillInAddress(place) {
  function getComponentName(componentType) {
    for (const component of place.address_components || []) {
      if (component.types[0] === componentType) {
        return SHORT_NAME_ADDRESS_COMPONENT_TYPES.has(componentType) ? component.short_name : component.long_name;
      }
    }
    return '';
  }

  function getComponentText(componentType) {
    return (componentType === 'location') ? `${getComponentName('street_number')} ${getComponentName('route')}` : getComponentName(componentType);
  }

  for (const componentType of ADDRESS_COMPONENT_TYPES_IN_FORM) {
    getFormInputElement(componentType).value = getComponentText(componentType);
  }
  if (place.geometry) {
    const latitudeField = document.getElementById('latitude-input');
    const longitudeField = document.getElementById('longitude-input');

    if (latitudeField && longitudeField) {
      latitudeField.value = place.geometry.location.lat();
      longitudeField.value = place.geometry.location.lng();
    }
  }
}

function renderAddress(place, map, marker) {
  if (place.geometry && place.geometry.location) {
    map.setCenter(place.geometry.location);
    marker.setPosition(place.geometry.location);
  } else {
    marker.position = null;
  }
}

export function initMap() {
  const { Map } = google.maps;
  const { Autocomplete } = google.maps.places;

  const mapOptions = CONFIGURATION.mapOptions;
  mapOptions.mapId = mapOptions.mapId || 'DEMO_MAP_ID';
  mapOptions.center = mapOptions.center || { lat: 48.8566, lng: 2.3522 }; // Paris coordinates

  const map = new Map(document.getElementById('gmp-map'), mapOptions);
  const marker = new google.maps.Marker({ map: map});
  const autocomplete = new Autocomplete(getFormInputElement('location'), {
    fields: ['address_components', 'geometry', 'name'],
    types: ['address'],
  });

  autocomplete.addListener('place_changed', () => {
    const place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert(`No details available for input: '${place.name}'`);
      return;
    }
    renderAddress(place, map, marker);
    fillInAddress(place);
  });
}

function initShowMap() {
  const mapElement = document.getElementById('gmp-map');
  const lat = parseFloat(mapElement.getAttribute('data-latitude'));
  const lng = parseFloat(mapElement.getAttribute('data-longitude'));

  if (!isNaN(lat) && !isNaN(lng)) {
    const mapOptions = {
      ...CONFIGURATION.mapOptions,
      center: { lat: lat, lng: lng },
      zoom: 15
    };

    const map = new google.maps.Map(mapElement, mapOptions);
    new google.maps.Marker({
      position: { lat: lat, lng: lng },
      map: map
    });
  }
}

