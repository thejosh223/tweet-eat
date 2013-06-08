module = angular.module 'tamad.errands', [

]

module.controller 'MyErrandsCtrl', ($scope) ->
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

