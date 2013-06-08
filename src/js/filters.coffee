module = angular.module 'tamad.filters', [

]

module.filter 'humanize', ->
  (x) -> moment.duration(x - (new Date())).humanize(true)

module.filter "photo", ->
  (fbid) ->
    "https://graph.facebook.com/#{fbid}/picture?type=large" # options later