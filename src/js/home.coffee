module = angular.module 'tamad.home', [
  'tamad.auth'
]


module.controller 'HomeLoggedInCtrl', ($scope, CurrentUser, $http, Errand) ->
  $scope.user = CurrentUser.data
  $scope.errands = Errand.query()
  filterErrands = ->
    $scope.filteredErrands = $scope.errands
    if $scope.searchText
      $scope.filteredErrands = _.filter $scope.filteredErrands, (errand) ->
        errand.body.indexOf($scope.searchText) != -1 and errand.title.indexOf($scope.searchText)
    lat = CurrentUser.data()?.user?.latitude
    long = CurrentUser.data()?.user?.longitude
    if lat? and long?
      latLng = new L.LatLng(lat, long)
      $scope.filteredErrands = _.sortBy $scope.filteredErrands, (errand) ->
        if errand.latitude? and errand.longitude?
          latLng.distanceTo(new L.LatLng(+errand.latitude, +errand.longitude))
        else
          1e9
        

  $scope.$watch 'errands', filterErrands
  $scope.$watch 'searchText', filterErrands
  $scope.$watch (-> CurrentUser.data().user.latitude), filterErrands
  $scope.run = (eid) ->
    console.log "you chose to run errand id: ", eid
    $http.post('/api/errands/apply',
      id: eid
    ).success (response) ->
      console.log "success", response
    .error (response) ->
      console.log "didn't finish run successfully", response

module.controller 'HomeAnonCtrl', ($scope) ->
  $scope.sampleErrands = [
    {
      fb_id: 100000775753811
      title: 'My Job'
      price: 10.0
    }
    {
      fb_id: 643054116
      title: 'Other Job'
      price: 20.0
    }
  ]
