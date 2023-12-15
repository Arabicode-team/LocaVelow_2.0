export async function initIndex() {
let markers = []; // Локальный массив для хранения маркеров
let map; // Локальная переменная карты
let mode = 'all'; // Локальный режим отображения
let searchParams = null; // Локальные параметры фильтра
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
    <div>
      <h3>${bicycle.model}</h3>
      <p><b>Type:</b> ${bicycle.bicycle_type}</p>
      <p><b>Size:</b> ${bicycle.size}</p>
      <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
      <a href="/bicycles/${bicycle.id}">View details</a>
    </div>`;
    const infowindow = new google.maps.InfoWindow({content: contentString});

    marker.addListener('click', () => {
      infowindow.open({ anchor: marker, map: map, shouldFocus: false });
    });

    markers.push(marker);
  });
}

function initIndexMap() {
  console.log("Initializing Index Map");
  
  // Очищаем предыдущие маркеры, если они есть
  if (markers.length > 0) {
    markers.forEach(marker => marker.setMap(null));
    markers = [];
  }

  const mapElement = document.getElementById('index-map');
  if (!mapElement) return;

  // Удаляем предыдущий экземпляр карты, если он существует
  if (map) {
    map = null;
  }

  map = new google.maps.Map(mapElement, {
    center: { lat: 48.8566, lng: 2.3522 },
    zoom: 10
  });

  setupAutocomplete();
  map.addListener('bounds_changed', function() {
    // Отложенный вызов функции загрузки данных, чтобы избежать чрезмерных запросов при быстром перемещении карты
    if (window.loadBicyclesDataTimeout) {
      clearTimeout(window.loadBicyclesDataTimeout);
    }
    window.loadBicyclesDataTimeout = setTimeout(loadBicyclesData, 500); // Задержка в 500 мс
  });
}

function loadBicyclesData() {
  const bounds = map.getBounds();
  const ne = bounds.getNorthEast();
  const sw = bounds.getSouthWest();
  const boundsParams = `ne_lat=${ne.lat()}&ne_lng=${ne.lng()}&sw_lat=${sw.lat()}&sw_lng=${sw.lng()}`;

  const jsonUrl = mode === 'all' ? `/bicycles.json?${boundsParams}` : `/bicycles_filtered.json?${searchParams}&${boundsParams}`;
  const htmlUrl = mode === 'all' ? `/bicycles?${boundsParams}` : `/bicycles_filtered?${searchParams}&${boundsParams}`;

  fetch(jsonUrl)
    .then(response => response.json())
    .then(loadMarkers)
    .catch(error => console.error('Error loading bicycles:', error));

  fetch(htmlUrl, {headers: {'Accept': 'text/html', 'X-Requested-With': 'XMLHttpRequest'}})
    .then(response => response.text())
    .then(html => document.getElementById('bicycles-list').innerHTML = html)
    .catch(error => console.error('Error loading bicycles list:', error));
}

document.addEventListener('turbo:load', function() {
  initIndexMap();

  const searchForm = document.getElementById('search-form');
  if (searchForm) {
    searchForm.addEventListener('submit', function(event) {
      event.preventDefault();
      const formData = new FormData(searchForm);
      searchParams = new URLSearchParams(formData).toString();
      mode = mode === 'all' ? 'filtered' : 'all';
      searchForm.querySelector('input[type="submit"]').value = mode === 'all' ? "Rechercher" : "Afficher tous";
      loadBicyclesData();
    });
  }
});
}

window.initIndex = initIndex;
// "use strict";

// let markers = []; // Глобальный массив для хранения текущих маркеров
// let map; // Переменная карты
// let mode = 'all'; // Режим отображения велосипедов
// let searchParams = null; // Параметры фильтра

// export async function initIndexMap() {
//   const mapElement = document.getElementById('index-map');
//   if (!mapElement) return;

//   // Настройки карты
//   const mapOptions = {
//     center: { lat: 48.8566, lng: 2.3522 },
//     zoom: 10,
//   };
//   map = new google.maps.Map(mapElement, mapOptions);
//   // Загрузка данных
//   loadBicyclesData();

//   // Автозаполнение и привязка к карте
//   setupAutocomplete();

// }

// function setupAutocomplete() {
//   const input = document.getElementById('city-input');
//   const autocomplete = new google.maps.places.Autocomplete(input, { types: ['(cities)'] });
//   autocomplete.bindTo('bounds', map);

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
//       map.setZoom(17);
//     }
//   });
// }

// function loadMarkers(bicycles) {
//   markers.forEach(marker => marker.setMap(null));
//   markers = [];

//   bicycles.forEach(bicycle => {
//     const marker = new google.maps.Marker({
//       position: { lat: bicycle.latitude, lng: bicycle.longitude },
//       map: map,
//       title: bicycle.model
//     });

//     const contentString = `
//     <div>
//       <h3>${bicycle.model}</h3>
//       <p><b>Type:</b> ${bicycle.bicycle_type}</p>
//       <p><b>Size:</b> ${bicycle.size}</p>
//       <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
//       <a href="/bicycles/${bicycle.id}">View details</a>
//     </div>`;
//     const infowindow = new google.maps.InfoWindow({
//       content: contentString
//     });

//     marker.addListener('click', () => {
//       infowindow.open({ anchor: marker, map: map, shouldFocus: false });
//     });

//     markers.push(marker);
//   });
// }

// const searchForm = document.getElementById('search-form');
// const submitButton = searchForm.querySelector('input[type="submit"]');

// function loadBicyclesData() {
//   // Определение URL в зависимости от режима
//   const jsonUrl = mode === 'all' ? '/bicycles.json' : `/bicycles_filtered.json?${searchParams}`;
//   const htmlUrl = mode === 'all' ? '/bicycles' : `/bicycles_filtered?${searchParams}`;

//   // Загрузка JSON для маркеров
//   fetch(jsonUrl)
//     .then(response => response.json())
//     .then(bicycles => {
//       loadMarkers(bicycles);
//     })
//     .catch(error => console.error('Error loading bicycles:', error));

//   // Загрузка HTML для списка велосипедов
//   fetch(htmlUrl, {
//     headers: { 'Accept': 'text/html', 'X-Requested-With': 'XMLHttpRequest'  }
//   })
//   .then(response => response.text())
//   .then(html => {
//     const turboFrame = document.getElementById('bicycles-list');
//     turboFrame.innerHTML = html;
//   })
//   .catch(error => console.error('Error loading bicycles list:', error));
// }

// searchForm.addEventListener('submit', function(event) {
//   event.preventDefault();

//   // Обновление параметров поиска и переключение режима
//   const formData = new FormData(searchForm);
//   searchParams = new URLSearchParams(formData).toString();

//   // Переключение текста кнопки и режима
//   if (mode === 'all') {
//     mode = 'filtered';
//     submitButton.value = "Afficher tous";
//   } else {
//     mode = 'all';
//     searchParams = null;
//     submitButton.value = "Rechercher";
//   }

//   // Загрузка данных
//   loadBicyclesData();
// });


// searchForm.addEventListener('submit', function(event) {
//   event.preventDefault();
//   const formData = new FormData(searchForm);
//   searchParams = new URLSearchParams(formData).toString();

//   if (mode === 'all') {
//     mode = 'filtered';
//     submitButton.value = "Afficher tous";
//     loadBicyclesData(); // Перезагрузка данных в новом режиме
//   } else {
//     mode = 'all';
//     searchParams = null; // Сброс параметров фильтра
//     submitButton.value = "Rechercher";
//     loadBicyclesData(); // Перезагрузка данных в новом режиме
//   }

// });


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

// let markers = []; // Глобальный массив для хранения текущих маркеров

// export async function initIndexMap() {
//   const mapElement = document.getElementById('index-map');

//   if (!mapElement) return;

//   const mapOptions = {
//     center: { lat: 48.8566, lng: 2.3522 },
//     zoom: 10,
//   };

//   const map = new google.maps.Map(mapElement, mapOptions);
//   loadMarkers(map);
//   setupAutocomplete(map);
//   setupBoundsChangedListener(map);
//   setupSearchForm(map);
// }

// function loadMarkers(map, bicycles = null) {
//   // Очистка предыдущих маркеров
//   markers.forEach(marker => marker.setMap(null));
//   markers = [];

//   // Если данные велосипедов не предоставлены, запрашиваем их
//   if (!bicycles) {
//     fetch('/bicycles.json')
//       .then(response => response.json())
//       .then(bicycles => addMarkers(map, bicycles))
//       .catch(error => console.error('Error loading bicycles:', error));
//   } else {
//     // Использование предоставленных данных велосипедов
//     addMarkers(map, bicycles);
//   }
// }

// function addMarkers(map, bicycles) {
//   bicycles.forEach(bicycle => {
//     if (bicycle.latitude && bicycle.longitude) {
//       const marker = new google.maps.Marker({
//         position: { lat: bicycle.latitude, lng: bicycle.longitude },
//         map: map,
//         title: bicycle.model
//       });

//       const contentString = `
//       <div>
//         <h3>${bicycle.model}</h3>
//         <p><b>Type:</b> ${bicycle.bicycle_type}</p>
//         <p><b>Size:</b> ${bicycle.size}</p>
//         <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
//         <a href="/bicycles/${bicycle.id}">View details</a>
//       </div>`;
//       const infowindow = new google.maps.InfoWindow({
//         content: contentString
//       });

//       marker.addListener('click', () => {
//         infowindow.open({ anchor: marker, map: map, shouldFocus: false });
//       });

//       markers.push(marker);
//     }
//   });
// }

// function setupAutocomplete(map) {
//   const input = document.getElementById('city-input');
//   const autocomplete = new google.maps.places.Autocomplete(input, { types: ['(cities)'] });
//   autocomplete.bindTo('bounds', map);

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
//       map.setZoom(17); 
//     }
//   });
// }

// let isIdleEventEnabled = true; // Переменная для контроля события idle

// function setupBoundsChangedListener(map) {
//   map.addListener('idle', () => {
//     if (!isIdleEventEnabled) return; // Пропускаем обработку, если поиск был выполнен

//     const bounds = map.getBounds();
//     const ne = bounds.getNorthEast();
//     const sw = bounds.getSouthWest();

//     fetch(`/bicycles_in_bounds?ne_lat=${ne.lat()}&ne_lng=${ne.lng()}&sw_lat=${sw.lat()}&sw_lng=${sw.lng()}`)
//       .then(response => response.text())
//       .then(html => {
//         updateBicyclesList(html);
//       });
//   });
// }

// function updateBicyclesList(data) {
//   const listContainer = document.getElementById('bicycles-list');
//   listContainer.innerHTML = data; // Предполагается, что 'data' содержит HTML
// }

// function setupSearchForm(map) {
//   const searchForm = document.getElementById('search-form');
//   if (!searchForm) return;

//   searchForm.addEventListener('submit', function(event) {
//     event.preventDefault();
//     isIdleEventEnabled = false; // Отключаем событие idle

//     const formData = new FormData(searchForm);
//     const searchParams = new URLSearchParams(formData).toString();

//     fetch(`/search_bicycles?${searchParams}`)
//       .then(response => response.json()) // Получаем JSON данные
//       .then(bicycles => {
//         updateBicyclesList(bicycles); // Обновляем список велосипедов
//         loadMarkers(map, bicycles); // Обновляем маркеры на карте
//       })
//       .finally(() => {
//         isIdleEventEnabled = true; // Включаем событие idle обратно
//       });
//   });
// }


// let markers = []; // Глобальный массив для хранения текущих маркеров
// let map;
// let isFilterActive = false; // Переменная для отслеживания активности фильтра
// let filterParams = null; // Параметры фильтра

// export async function initIndexMap() {
//     const mapElement = document.getElementById('index-map');
//     if (!mapElement) return;

//     const mapOptions = {
//         center: { lat: 48.8566, lng: 2.3522 },
//         zoom: 10,
//     };

//     map = new google.maps.Map(mapElement, mapOptions);
//     loadBicyclesList(); // Загрузка списка велосипедов при инициализации
//     setupAutocomplete(map);
//     setupBoundsChangedListener(map);
//     setupSearchForm();
// }

// function loadBicyclesList() {
//     let fetchUrl = isFilterActive ? `/bicycles_in_bounds_filtered?${filterParams}` : '/bicycles_in_bounds';
//     fetch(fetchUrl)
//         .then(response => response.text())
//         .then(html => {
//             document.getElementById('bicycles-list').innerHTML = html;
//             updateMarkersFromList();
//         })
//         .catch(error => console.error('Error loading bicycles:', error));
// }

// function updateMarkersFromList() {
//     markers.forEach(marker => marker.setMap(null));
//     markers = [];

//     document.querySelectorAll('#bicycles-list .bicycle').forEach(bicycleElement => {
//         const latitude = parseFloat(bicycleElement.dataset.latitude);
//         const longitude = parseFloat(bicycleElement.dataset.longitude);
//         const title = bicycleElement.dataset.title;

//         if (!isNaN(latitude) && !isNaN(longitude)) {
//             const marker = new google.maps.Marker({
//                 position: { lat: latitude, lng: longitude },
//                 map: map,
//                 title: title
//             });

//       const contentString = `
//       <div>
//         <h3>${bicycle.model}</h3>
//         <p><b>Type:</b> ${bicycle.bicycle_type}</p>
//         <p><b>Size:</b> ${bicycle.size}</p>
//         <p><b>Prix par heure: </b>${bicycle.price_per_hour} &euro;</p>
//         <a href="/bicycles/${bicycle.id}">View details</a>
//       </div>`;
//       const infowindow = new google.maps.InfoWindow({
//         content: contentString
//       });

//       marker.addListener('click', () => {
//         infowindow.open({ anchor: marker, map: map, shouldFocus: false });
//       });

//       markers.push(marker);
//     }
//   });
// }

// // Остальные функции остаются без изменений


// function setupAutocomplete(map) {
//   const input = document.getElementById('city-input');
//   const autocomplete = new google.maps.places.Autocomplete(input, { types: ['(cities)'] });
//   autocomplete.bindTo('bounds', map);

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
//       map.setZoom(17); 
//     }
//   });
// }


// function setupBoundsChangedListener(map) {
//   map.addListener('idle', () => {
//     const bounds = map.getBounds();
//     const ne = bounds.getNorthEast();
//     const sw = bounds.getSouthWest();

//     if (isFilterActive) {
//       // Фильтрованный запрос
//       const formData = new FormData(document.getElementById('search-form'));
//       const searchParams = new URLSearchParams(formData).toString();

//       fetch(`/bicycles_in_bounds_filtered?ne_lat=${ne.lat()}&ne_lng=${ne.lng()}&sw_lat=${sw.lat()}&sw_lng=${sw.lng()}&${searchParams}`)
//         .then(response => response.text())
//         .then(html => {
//           updateBicyclesList(html);
//         });
//     } else {
//       // Запрос всех велосипедов
//       fetch(`/bicycles_in_bounds?ne_lat=${ne.lat()}&ne_lng=${ne.lng()}&sw_lat=${sw.lat()}&sw_lng=${sw.lng()}`)
//         .then(response => response.text())
//         .then(html => {
//           updateBicyclesList(html);
//         });
//     }
//   });
// }


// function setupSearchForm() {
//   const searchForm = document.getElementById('search-form');
//   const submitButton = searchForm.querySelector('input[type="submit"]');

//   searchForm.addEventListener('submit', function(event) {
//       event.preventDefault();

//       const formData = new FormData(searchForm);
//       filterParams = new URLSearchParams(formData).toString();

//       if (!isFilterActive) {
//           // Загрузка отфильтрованного списка велосипедов
//           loadBicyclesList();
//           isFilterActive = true;
//           submitButton.value = "Afficher tous";
//       } else {
//           // Загрузка списка всех велосипедов
//           filterParams = null; // Сброс параметров фильтра
//           loadBicyclesList();
//           isFilterActive = false;
//           submitButton.value = "Rechercher";
//       }
//   });
// }