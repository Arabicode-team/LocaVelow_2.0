"use strict";

async function initIndexMap() {
  const { Map, Marker, InfoWindow } = google.maps;
  const mapElement = document.getElementById('index-map');

  if (!mapElement) return;

  const mapOptions = {
    center: { "lat":48.8566,"lng":2.3522 },
    zoom: 10,
  };

  const map = new Map(mapElement, mapOptions);

  fetch('/bicycles.json')
    .then(response => response.json())
    .then(bicycles => {
      bicycles.forEach(bicycle => {
        if (bicycle.latitude && bicycle.longitude) {
          const marker = new Marker({
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
          const infowindow = new InfoWindow({
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

window.initIndexMap = initIndexMap;
