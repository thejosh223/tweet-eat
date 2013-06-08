module = angular.module 'tamad.home', [
  'tamad.auth'
]

module.controller 'HomeCtrl', ($scope, CurrentUser) ->
  setHomeUrl = ->
    if CurrentUser.loggedIn()
      $scope.homeUrl = '/html/home_logged_in.html'
    else
      $scope.homeUrl = '/html/home_anon.html'

  $scope.$on 'login-changed', (event) ->
    setHomeUrl()

  setHomeUrl()


module.controller 'HomeLoggedInCtrl', ($scope, CurrentUser, $http, Errand) ->
  $scope.user = CurrentUser.data
  $scope.errands = Errand.query (errands) ->
    filterErrands()

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
  $scope.run = (errand) ->
    console.log "you chose to run errand:", errand
    $http.post("/api/errands/#{errand.id}/apply").success (response) ->
      console.log "success", response
    .error (response) ->
      console.log "didn't finish run successfully", response

module.controller 'HomeAnonCtrl', ($scope, Errand) ->
  $scope.sampleErrands = [
    {
      title: 'Blah'
      price: 100.00
    }
  ]
