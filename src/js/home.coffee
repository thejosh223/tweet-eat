module = angular.module 'tamad.home', [

]

module.controller 'HomeCtrl', ($scope) ->
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

