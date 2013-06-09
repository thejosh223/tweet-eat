"use strict"

module = angular.module 'tamad.profile', [

]

module.controller 'ProfileCtrl', ['$scope', '$http', 'CurrentUser', 'Toastr', ($scope, $http, CurrentUser, Toastr) ->
  $scope.rating_average = 0
  $scope.rating_count = 0
  $scope.user = CurrentUser.data()
  user = $scope.user
  user.id = 1
  $scope.stars = [1,2,3,4,5]
  console.log "Hey", user.id
  $http.get("/api/users/#{user.id}/ratings")
    .success (resp) ->
      console.log "got resp", resp
      $scope.requests = resp
      if resp.length > 0
        sum = _.reduce(resp, ((memo, req) -> memo + req.rating), 0)
        $scope.rating_average = sum/resp.length
        $scope.rating_count = resp.length
      else
        $scope.rating_average = 0
        $scope.rating_count = 0
    .error (err) ->
      Toastr.error 'Something went wrong. Please try again.'
]
