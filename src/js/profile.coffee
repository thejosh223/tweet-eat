"use strict"

module = angular.module 'tamad.profile', [

]

module.controller 'ProfileCtrl', ['$scope', '$http', 'CurrentUser', 'Toastr', ($scope, $http, CurrentUser, Toastr) ->
  $scope.rating_average = 0
  $scope.rating_count = 0
  $scope.errands = []
  $scope.user = CurrentUser.data()
  user = $scope.user
  user.id = 1

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
      console.log 'Yay', resp
      $scope.errands = resp
    .error (err) ->
      Toastr.error 'Something went wrong. Please try again.'

]
