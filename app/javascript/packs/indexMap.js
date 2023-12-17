let markers = [];
let map;
let mode = 'all';
let searchParams = null;
window.loadBicyclesDataTimeout = null;

function setupAutocomplete() {
  const input = document.getElementById('city-input');
  if (!input) return;

  const autocomplete = new google.maps.places.Autocomplete(input, { types: ['(cities)'] });
  autocomplete.bindTo('bounds', map);

  autocomplete.addListener('place_changed', function() {
    const place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(17);
    }
  });
}

function loadMarkers(bicycles) {
  markers.forEach(marker => marker.setMap(null));
  markers = [];

  bicycles.forEach(bicycle => {
    const marker = new google.maps.Marker({
      position: { lat: bicycle.latitude, lng: bicycle.longitude },
      map: map,
      title: bicycle.model
    });

    const contentString = `
      <div class="col text-center">
        <img src="${bicycle.image_url || '/assets/icone_vélo.png'}" alt="${bicycle.model}" style="width:130px;height:100px;">
        <h3>${bicycle.model}</h3>
        <p><b>Taille:</b> ${bicycle.size}</p>
        <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
        <a href="/bicycles/${bicycle.id}" aria-label="View details about ${bicycle.model}">View details</a>
      </div>`;
      
    const infowindow = new google.maps.InfoWindow({content: contentString});

    marker.addListener('click', () => {
      infowindow.open({ anchor: marker, map: map, shouldFocus: false });
    });

    markers.push(marker);
  });
}

export function initIndexMap() {
  console.log("Initializing Index Map");

  if (markers.length > 0) {
    markers.forEach(marker => marker.setMap(null));
    markers = [];
  }

  const mapElement = document.getElementById('index-map');
  if (!mapElement) return;

  if (map) {
    map = null;
  }

  map = new google.maps.Map(mapElement, {
    center: { lat: 48.8566, lng: 2.3522 },
    zoom: 10
  });

  setupAutocomplete();
  map.addListener('bounds_changed', function() {
    if (window.loadBicyclesDataTimeout) {
      clearTimeout(window.loadBicyclesDataTimeout);
    }
    window.loadBicyclesDataTimeout = setTimeout(loadBicyclesData, 500);
  });

  const searchForm = document.getElementById('search-form');
  if (searchForm) {
    searchForm.addEventListener('submit', function(event) {
      event.preventDefault();
      const formData = new FormData(searchForm);
      searchParams = new URLSearchParams(formData).toString();
      mode = mode === 'all' ? 'filtered' : 'all';
      searchForm.querySelector('input[type="submit"]').value = mode === 'all' ? "Rechercher" : "Afficher tous";
      loadBicyclesData();
      toggleDateAndDurationFields(mode === 'all');
    });
  }
  toggleDateAndDurationFields(mode === 'all');
}

async function loadBicyclesData() {
  const bounds = map.getBounds();
  const ne = bounds.getNorthEast();
  const sw = bounds.getSouthWest();
  const boundsParams = `ne_lat=${ne.lat()}&ne_lng=${ne.lng()}&sw_lat=${sw.lat()}&sw_lng=${sw.lng()}`;

  const jsonUrl = mode === 'all' ? `/bicycles.json?${boundsParams}` : `/bicycles_filtered.json?${searchParams}&${boundsParams}`;
  const htmlUrl = mode === 'all' ? `/bicycles?${boundsParams}` : `/bicycles_filtered?${searchParams}&${boundsParams}`;

  try {
    const responseJson = await fetch(jsonUrl);
    const bicycles = await responseJson.json();
    loadMarkers(bicycles);

    const responseHtml = await fetch(htmlUrl, {headers: {'Accept': 'text/html', 'X-Requested-With': 'XMLHttpRequest'}});
    const html = await responseHtml.text();
    document.getElementById('bicycles-list').innerHTML = html;
  } catch (error) {
    console.error('Error loading bicycles:', error);
  }
  toggleDateAndDurationFields(mode === 'all');
}

function toggleDateAndDurationFields(enable) {
  const dateInput = document.getElementById('start-date-input');
  const durationInput = document.getElementById('duration-input');

  if (dateInput && durationInput) {
    dateInput.disabled = !enable;
    durationInput.disabled = !enable;
  }
}
