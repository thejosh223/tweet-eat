module = angular.module 'tamad.runner', [

]

module.controller 'AcceptedErrandsCtrl', ($scope, Errand) ->
  $scope.errands = Errand.query()
