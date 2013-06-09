module = angular.module 'tamad.nav', [

]

module.controller 'NavCtrl', ($scope, $http, $timeout, $location) ->
  $scope.pendingRequests = []
  $scope.acceptedRequests = []

  pollPending =  () ->
    $http.get('/api/errand_requests/pending')
      .success (resp) ->
        $scope.pendingRequests = resp
        $timeout pollPending, 5000
      .error (err) ->
        console.log err
        $timeout pollPending, 5000

  pollPending()

  pollAccepted =  () ->
    $http.get('/api/errands/accepted')
      .success (resp) ->
        $scope.acceptedRequests = resp
        $timeout pollAccepted, 5000
      .error (err) ->
        console.log err
        $timeout pollAccepted, 5000

  pollAccepted()

  $scope.postErrand = ->
    $('#new-errand').show()

  $scope.$watch (->$location.path()), (val) ->
    $scope.path = val
