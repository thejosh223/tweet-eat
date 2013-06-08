module = angular.module 'tamad.errands', [
  'tamad.resources'
]


module.controller 'MyErrandsCtrl', ($scope, Errand) ->
  query = ->
    $scope.errands = Errand.query()

  query()
  $scope.$on 'save-errand', (event) ->
    query()

module.controller 'ErrandCreationCtrl', ($scope, CurrentUser, Errand) ->
  $scope.errand =
    deadline: null
  isDefault = not CurrentUser.data().user.latitude?
  lat = CurrentUser.data().user.latitude ? 14.566
  long = CurrentUser.data().user.longitude ? 121.034
  zoomLevel = if isDefault then 11 else 14
  map = L.map('location-map').setView([lat, long], zoomLevel)
  L.tileLayer('http://b.tile.cloudmade.com/bce295a2a50d43a2bb2dbebef4ea99e4/4/256/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="http://cloudmade.com">CloudMade</a>',
      maxZoom: 18
  }).addTo(map)

  popup = L.marker()
  if not isDefault
    popup.setLatLng(new L.LatLng(lat, long)).addTo(map)
       
  $scope.today = new Date()

  map.on 'click', (e) ->
    if e.latlng?
      popup.setLatLng(e.latlng).addTo(map)
      $scope.errand.latitude = e.latlng.lat
      $scope.errand.longitude = e.latlng.lng

  $scope.submit = ->
    # save $scope.errand.latitude/longitude to user

    Errand.save $scope.errand, (success) ->
      $scope.$emit 'save-errand'

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
        $scope.pendingRequests = []
        $timeout pollPending, 1000

  pollPending()

  pollAccepted =  () ->
    $http.get('/api/errands/accepted')
      .success (resp) ->
        $scope.acceptedRequests = resp
        $timeout pollAccepted, 1000
      .error (err) ->
        console.log err
        $scope.acceptedRequests = []
        $timeout pollAccepted, 1000

  pollAccepted()
