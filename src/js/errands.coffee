module = angular.module 'tamad.errands', [
  'tamad.resources'
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

module.controller 'ErrandCreationCtrl', ($scope, Errand) ->
  $scope.submit = () ->
    errand = new Errand
      title: $scope.title
      body: $scope.body
      deadline: $scope.deadline
    errand.$save() 
