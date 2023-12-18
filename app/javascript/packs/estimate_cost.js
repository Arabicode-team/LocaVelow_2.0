export function estimateCost() {
  const form = document.getElementById('rental_form');
  if (!form) return;

  const pricePerHour = parseFloat(form.dataset.pricePerHour);
  const startDateField = form.querySelector('[name="rental[start_date]"]');
  const endDateField = form.querySelector('[name="rental[end_date]"]');
  const submitButton = form.querySelector('input[type="submit"]');
  const costDisplay = document.getElementById('calculated_cost');

  function validateForm() {
    const now = new Date();
    const startDateTime = new Date(startDateField.value);
    const endDateTime = new Date(endDateField.value);

    const datesAreValid = startDateTime >= now && endDateTime > startDateTime;

    if (datesAreValid) {
      const duration = (endDateTime - startDateTime) / 36e5;
      const cost = duration * pricePerHour;
      costDisplay.textContent = 'Prix total estimé: ' + cost.toFixed(2) + '€';
      submitButton.disabled = false;
    } else {
      costDisplay.textContent = 'Date invalide';
      submitButton.disabled = true;
    }
  }

  startDateField.addEventListener('change', validateForm);
  endDateField.addEventListener('change', validateForm);

  validateForm();
}


