module = angular.module 'tamad.filters', [

]

module.filter 'humanize', ->
  (x) -> moment.duration(x - (new Date())).humanize(true)

module.filter 'distance', ->
  (a, b) ->
    if a?.latitude? and b?.latitude?
      dist = new L.LatLng(a.latitude, a.longitude).distanceTo(new L.LatLng(b.latitude, b.longitude))/1000.0
      if dist < 1
        '<1 km away'
      else
        "#{dist.toFixed(2)} km away"


module.filter "photo", ->
  (fbid) ->
    if fbid?
      "https://graph.facebook.com/#{fbid}/picture?width=100&height=100" # options later
    else
      # find a better default 'no picture' icon
      "http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm"

module.filter "profilepic", ->
  (fbid) ->
    if fbid?
      "https://graph.facebook.com/#{fbid}/picture?width=200&height=200" # options later
    else
      # find a better default 'no picture' icon
      "http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm"
