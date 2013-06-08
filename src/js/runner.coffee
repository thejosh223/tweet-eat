"use strict"

module = angular.module 'tamad.runner', [

]

module.controller 'AcceptedErrandsCtrl', ($scope, $http) ->
  $http.get('/api/errand_requests').success (requests) ->
    $scope.errands = requests

