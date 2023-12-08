document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('rental_form');
  const pricePerHour = parseFloat(form.dataset.pricePerHour);
  const startDateField = form.querySelector('[name="rental[start_date]"]');
  const endDateField = form.querySelector('[name="rental[end_date]"]');
  const costDisplay = document.getElementById('calculated_cost');

  form.addEventListener('change', function () {
    calculateCost();
  });

  function calculateCost() {
    if (!startDateField.value || !endDateField.value) {
      console.error("Start date or end date is missing.");
      return;
    }

    const startDateTime = new Date(startDateField.value);
    const endDateTime = new Date(endDateField.value);
    const duration = (endDateTime - startDateTime) / 36e5; 
    if(duration > 0){
      const cost = duration * pricePerHour;
      costDisplay.textContent = 'Prix total : ' + cost.toFixed(2) + '€';
    } else {
      costDisplay.textContent = 'Prix total : 0 €';
    }
  }
});
