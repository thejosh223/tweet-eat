"use strict"

module = angular.module 'tamad.profile', [

]

module.controller 'ProfileCtrl', ['$scope', '$http', 'CurrentUser', ($scope, $http, CurrentUser) ->
  $scope.rating_average = 0
  $scope.rating_count = 0
  $scope.errands = []
  $scope.requests = []
  $scope.user = CurrentUser.data()
  user = $scope.user

  $http.get("/api/users/#{user.id}/ratings")
    .success (resp) ->
      if resp.length > 0
        sum = _.reduce(resp, ((memo, rating) -> memo + rating.score), 0)
        $scope.rating_average = sum/resp.length
        $scope.rating_count = resp.length
      else
        $scope.rating_average = 0
        $scope.rating_count = 0
    .error (err) ->
      Toastr.error 'Something went wrong. Please try again.'

  $http.get("/api/users/#{user.id}/errands")
    .success (resp) ->
      $scope.errands = resp
    .error (err) ->
      Toastr.error 'Something went wrong. Please try again.'

  $http.get("/api/users/#{user.id}/requests")
    .success (resp) ->
      $scope.requests = resp
    .error (err) ->
      Toastr.error 'Something went wrong. Please try again.'

  console.log "profile setup"
]
