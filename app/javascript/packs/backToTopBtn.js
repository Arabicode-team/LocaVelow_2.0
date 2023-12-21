// app/javascript/backToTopButton.js

function scrollToTop() {
    document.body.scrollTop = 0; // Для Safari
    document.documentElement.scrollTop = 0; // Для Chrome, Firefox, IE и Opera
  }
  
  function handleScroll() {
    let mybutton = document.getElementById("myBtn");
  
    if (!mybutton) return;
  
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
      mybutton.style.display = "block";
    } else {
      mybutton.style.display = "none";
    }
  }
  
  document.addEventListener('turbo:load', function() {
    window.addEventListener('scroll', handleScroll);
    const mybutton = document.getElementById("myBtn");
    if (mybutton) {
      mybutton.addEventListener('click', function(event) {
        event.preventDefault();
        scrollToTop();
    });
}
}); ̀