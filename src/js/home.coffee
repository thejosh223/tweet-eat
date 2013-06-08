module = angular.module 'tamad.home', [
  'tamad.auth'
]

module.controller 'HomeCtrl', ($scope, CurrentUser) ->
  if CurrentUser.loggedIn()
    $scope.home_url = '/html/home_logged_in.html'
  else
    $scope.home_url = '/html/home_anon.html'


module.controller 'HomeLoggedInCtrl', ($scope, CurrentUser) ->
  $scope.user = CurrentUser.data
  $scope.errands = [
    {
      title: 'A random job'
      price:  100.00
      id: 1
      deadline: new Date((new Date().getTime()) + 3600e3)
      user:
        fb_id: 100000775753811
    }
    {
      title: 'Another job'
      price:  200.00
      id: 2
      deadline: new Date(new Date().getTime() + 240e3)
      user:
        fb_id: 643054116
    }
  ]

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
