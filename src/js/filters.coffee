module = angular.module 'tamad.filters', [

]

module.filter 'humanize', ->
  (x) -> moment.duration(x - (new Date())).humanize(true)

module.filter 'distance', ->
  (a, b) ->
    L.LatLng(a.latitude, a.longitude).distanceTo(L.LatLng(b.latitude, b.longitude))

