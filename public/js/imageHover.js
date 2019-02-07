cards = document.querySelectorAll('.image-trigger');
image = document.querySelector('.cardimage');

changeImage = function (event) {
    image.src = event.currentTarget.classList[1];
}

cards.forEach(function(card) {
    card.addEventListener('mouseover',changeImage)
});
