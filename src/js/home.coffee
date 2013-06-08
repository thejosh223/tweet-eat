module = angular.module 'tamad.home', [
  'tamad.auth'
]

module.controller 'HomeCtrl', ($scope, CurrentUser) ->
  if CurrentUser.loggedIn()
    $scope.home_url = '/html/home_logged_in.html'
  else
    $scope.home_url = '/html/home_anon.html'


module.controller 'HomeLoggedInCtrl', ($scope) ->
  $scope.errands = [
    {
      title: 'A random job'
      price:  100.00
      id: 1
    }
    {
      title: 'Another job'
      price:  200.00
      id: 2
    }
  ]

module.controller 'HomeAnonCtrl', ($scope) ->
  $scope.sampleErrands = [
    {
      photo: null
      title: 'My Job'
      price: 10.0
    }
    {
      photo: null
      title: 'Other Job'
      price: 20.0
    }
  ]
