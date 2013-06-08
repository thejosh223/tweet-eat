module = angular.module 'tamad.nav', [

]

module.controller 'NavCtrl', ($scope, $http, $timeout, $location) ->
  $scope.pendingRequests = []
  $scope.acceptedRequests = []

  pollPending =  () ->
    $http.get('/api/errand_requests/pending')
      .success (resp) ->
        $scope.pendingRequests = resp
        $timeout pollPending, 1000
      .error (err) ->
        console.log err
        $timeout pollPending, 1000

#  pollPending()

  pollAccepted =  () ->
    $http.get('/api/errands/accepted')
      .success (resp) ->
        $scope.acceptedRequests = resp
        $timeout pollAccepted, 1000
      .error (err) ->
        console.log err
        $timeout pollAccepted, 1000

#  pollAccepted()

  $scope.postErrand = ->
    $('#new-errand').show()

  $scope.$watch (->$location.path()), (val) ->
    $scope.path = val
