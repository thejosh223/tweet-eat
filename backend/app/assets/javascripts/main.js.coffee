$ ->
  cloudWords = window.cloudWords
  pageId = $('#content > div:first-child').attr('id')

  if pageId == 'restaurant-page'
    $('#wordcloud').jQCloud({text : datum.word, weight: datum.weight} for datum in cloudWords)
  else if pageId == 'map-page'
    map = L.map('map').setView([51.505, -0.09], 13)
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map)

    L.marker([51.5, -0.09]).addTo(map)
        .bindPopup('A pretty CSS3 popup. <br> Easily customizable.')
        .openPopup()
