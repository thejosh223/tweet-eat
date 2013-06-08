module = angular.module 'tamad.filters', [

]

module.filter 'humanize', ->
  (x) -> moment.duration(x - (new Date())).humanize(true)
