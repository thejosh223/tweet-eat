module = angular.module 'tamad.home', [
  'tamad.auth'
]

module.controller 'HomeCtrl', ($scope, CurrentUser) ->
  if CurrentUser.loggedIn()
    $scope.home_url = '/html/home_logged_in.html'
  else
    $scope.home_url = '/html/home_anon.html'


module.controller 'HomeLoggedInCtrl', ($scope, CurrentUser, $http, Errand) ->
  $scope.user = CurrentUser.data
  $scope.errands = Errand.query()
  $scope.run = (eid) ->
    console.log "you chose to run errand id: ", eid
    $http.post("/api/errands/#{eid}/apply").success (response) ->
      console.log "success", response
    .error (response) ->
      console.log "didn't finish run successfully", response

module.controller 'HomeAnonCtrl', ($scope, Errand) ->
  $scope.errands = Errand.query()
