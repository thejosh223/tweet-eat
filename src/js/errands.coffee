module = angular.module 'tamad.errands', [
  'tamad.resources'
]


module.controller 'MyErrandsCtrl', ($scope, Errand) ->
  $scope.errands = Errand.query()

module.controller 'ErrandCreationCtrl', ($scope, Errand) ->
  $scope.errand = {}
  map = L.map('location-map').setView([14.566, 121.034], 11)
  L.tileLayer('http://b.tile.cloudmade.com/bce295a2a50d43a2bb2dbebef4ea99e4/4/256/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="http://cloudmade.com">CloudMade</a>',
      maxZoom: 18
  }).addTo(map)

  popup = L.marker()
  map.on 'click', (e) ->
    popup.setLatLng(e.latlng).addTo(map)

  $scope.submit = ->
    console.log $scope.errand
    Errand.save($scope.errand)

module.controller 'NotificationCtrl', ($scope, $http, $timeout) ->
  $scope.pendingRequests = []
  $scope.acceptedRequests = []

  pollPending =  () ->
    $http.get('/api/errand_requests/pending')
      .success (resp) ->
        $scope.pendingRequests = resp
        $timeout pollPending, 1000
      .error (err) ->
        console.log err
        $timeout pollPending, 1000

  pollPending()

  pollAccepted =  () ->
    $http.get('/api/errands/accepted')
      .success (resp) ->
        $scope.acceptedRequests = resp
        $timeout pollAccepted, 1000
      .error (err) ->
        console.log err
        $timeout pollAccepted, 1000

  pollAccepted()

