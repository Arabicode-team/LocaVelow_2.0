// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { initMap } from "./packs/autocompleteMap";
import { initIndex } from "./packs/indexMap";
import { initSimpleMap } from "./packs/simpleMap";
import { estimateCost } from "./packs/estimate_cost";

function initMaps() {
  const isFormPage = document.getElementById('location-input') !== null; // Проверка на наличие поля автозаполнения

  if (isFormPage) {
    initMap(); // Функция для инициализации карты с автозаполнением на форме
  } else {
    if (document.getElementById('index-map')) {
      initIndex(); // Функция для карты на главной странице
    }
    if (document.getElementById('gmp-map')) {
      initSimpleMap(); // Функция для простой карты
    }
  }
}

function initConditionalScripts() {
  // Проверяем, нужно ли инициализировать карты
  if (document.getElementById('index-map') || document.getElementById('gmp-map') || document.getElementById('location-input')) {
    initMaps();
  }

  // Проверяем, нужно ли инициализировать расчет стоимости
  if (document.getElementById('rental_form')) {
    estimateCost();
  }
}

document.addEventListener('turbo:load', function () {
  // Инициализация карт и расчета стоимости
  initConditionalScripts();
});

window.initMaps = initMaps;
window.initConditionalScripts = initConditionalScripts;

