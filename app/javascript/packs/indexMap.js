// "use strict";

// export async function initIndexMap() {
//   console.log("initIndexMap called");
//   const { Map, Marker, InfoWindow } = google.maps;
//   const mapElement = document.getElementById('index-map');

//   if (!mapElement) return;

//   const mapOptions = {
//     center: { "lat":48.8566,"lng":2.3522 },
//     zoom: 10,
//   };

//   const map = new Map(mapElement, mapOptions);

//   const input = document.getElementById('city-input'); // Элемент для автозаполнения
//   const autocomplete = new google.maps.places.Autocomplete(input, {types: ['(cities)']}); // Ограничить поиск только городами

//   autocomplete.bindTo('bounds', map); // Привязка автозаполнения к карте

//   autocomplete.addListener('place_changed', function() {
//     const place = autocomplete.getPlace();
//     if (!place.geometry) {
//       window.alert("No details available for input: '" + place.name + "'");
//       return;
//     }

//     if (place.geometry.viewport) {
//       map.fitBounds(place.geometry.viewport);
//     } else {
//       map.setCenter(place.geometry.location);
//       map.setZoom(17); // Можно настроить масштаб
//     }

//   });

//   fetch('/bicycles.json')
//     .then(response => response.json())
//     .then(bicycles => {
//       bicycles.forEach(bicycle => {
//         if (bicycle.latitude && bicycle.longitude) {
//           const marker = new Marker({
//             position: { lat: bicycle.latitude, lng: bicycle.longitude },
//             map: map,
//             title: bicycle.model
//           });

//           const contentString = `
//           <div>
//             <h3>${bicycle.model}</h3>
//             <p><b>Type:</b> ${bicycle.bicycle_type}</p>
//             <p><b>Size:</b> ${bicycle.size}</p>
//             <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
//             <a href="/bicycles/${bicycle.id}">View details</a>
//           </div>`;
//           const infowindow = new InfoWindow({
//             content: contentString
//           });

//           marker.addListener('click', () => {
//             infowindow.open({
//               anchor: marker,
//               map: map,
//               shouldFocus: false,
//             });
//           });
//         }
//       });
//     })
//     .catch(error => console.error('Error loading bicycles:', error));

// }
// "use strict";

// export async function initIndexMap() {
//   console.log("initIndexMap called");
//   const mapElement = document.getElementById('index-map');

//   if (!mapElement) return;

//   const mapOptions = {
//     center: { "lat":48.8566,"lng":2.3522 },
//     zoom: 10,
//   };

//   const map = new Map(mapElement, mapOptions);
//   loadMarkers(map);
//   setupAutocomplete(map);
//   setupBoundsChangedListener(map);
// }

// function loadMarkers(map) {
//   fetch('/bicycles.json')
//   .then(response => response.json())
//   .then(bicycles => {
//     bicycles.forEach(bicycle => {
//       if (bicycle.latitude && bicycle.longitude) {
//         const marker = new Marker({
//           position: { lat: bicycle.latitude, lng: bicycle.longitude },
//           map: map,
//           title: bicycle.model
//         });

//         const contentString = `
//         <div>
//           <h3>${bicycle.model}</h3>
//           <p><b>Type:</b> ${bicycle.bicycle_type}</p>
//           <p><b>Size:</b> ${bicycle.size}</p>
//           <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
//           <a href="/bicycles/${bicycle.id}">View details</a>
//         </div>`;
//         const infowindow = new InfoWindow({
//           content: contentString
//         });

//         marker.addListener('click', () => {
//           infowindow.open({
//             anchor: marker,
//             map: map,
//             shouldFocus: false,
//           });
//         });
//       }
//     });
//   })
//   .catch(error => console.error('Error loading bicycles:', error));

// }

export async function initIndexMap() {
  console.log("initIndexMap called");
  const mapElement = document.getElementById('index-map');

  if (!mapElement) return;

  const mapOptions = {
    center: { "lat":48.8566,"lng":2.3522 },
    zoom: 10,
  };

  const map = new google.maps.Map(mapElement, mapOptions);
  loadMarkers(map);
  setupAutocomplete(map);
  setupBoundsChangedListener(map);
}

function loadMarkers(map) {
  fetch('/bicycles.json')
  .then(response => response.json())
  .then(bicycles => {
    bicycles.forEach(bicycle => {
      if (bicycle.latitude && bicycle.longitude) {
        const marker = new google.maps.Marker({
          position: { lat: bicycle.latitude, lng: bicycle.longitude },
          map: map,
          title: bicycle.model
        });

        const contentString = `
        <div>
          <h3>${bicycle.model}</h3>
          <p><b>Type:</b> ${bicycle.bicycle_type}</p>
          <p><b>Size:</b> ${bicycle.size}</p>
          <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
          <a href="/bicycles/${bicycle.id}">View details</a>
        </div>`;
        const infowindow = new google.maps.InfoWindow({
          content: contentString
        });

        marker.addListener('click', () => {
          infowindow.open({
            anchor: marker,
            map: map,
            shouldFocus: false,
          });
        });
      }
    });
  })
  .catch(error => console.error('Error loading bicycles:', error));

}

function setupAutocomplete(map) {
  const input = document.getElementById('city-input');
  const autocomplete = new google.maps.places.Autocomplete(input, {types: ['(cities)']});
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


function setupBoundsChangedListener(map) {
  map.addListener('idle', () => {
    const bounds = map.getBounds();
    const ne = bounds.getNorthEast();
    const sw = bounds.getSouthWest();

    fetch(`/bicycles_in_bounds?ne_lat=${ne.lat()}&ne_lng=${ne.lng()}&sw_lat=${sw.lat()}&sw_lng=${sw.lng()}`)
      .then(response => response.text())
      .then(html => {
        updateBicyclesList(html); // Функция для обновления списка велосипедов
      });
  });
}

function updateBicyclesList(data) {
  const listContainer = document.getElementById('bicycles-list');
  listContainer.innerHTML = data; // Предполагается, что 'data' содержит HTML
}

