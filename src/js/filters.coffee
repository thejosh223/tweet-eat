module = angular.module 'tamad.filters', [

]

module.filter 'humanize', ->
  (x) -> moment.duration(x - (new Date())).humanize(true)

module.filter 'distance', ->
  (a, b) ->
    if a?.latitude? and b?.latitude?
      L.LatLng(a.latitude, a.longitude).distanceTo(L.LatLng(b.latitude, b.longitude))


module.filter "photo", ->
  (fbid) ->
    if fbid?
      "https://graph.facebook.com/#{fbid}/picture?type=large" # options later
    else
      # find a better default 'no picture' icon
      ""
