"use strict"

module = angular.module 'tamad.profile', [

]

module.controller 'ProfileCtrl', ['$scope', '$http', 'CurrentUser', 'Toastr', ($scope, $http, CurrentUser, Toastr) ->
  $scope.rating_average = 0
  $scope.rating_count = 0
  $scope.ratings = [
    { title: 'Title One', citation: 'Bruce Wayne1', comment: 'This is Batman\'s comment.', score: 1 }
    { title: 'Title Two', citation: 'Bruce Wayne2', comment: 'This is Batman\'s comment.', score: 2 }
    { title: 'Title Thr', citation: 'Bruce Wayne3', comment: 'This is Batman\'s comment.', score: 3 }
    { title: 'Title Fou', citation: 'Bruce Wayne4', comment: 'This is Batman\'s comment.', score: 4 }
    { title: 'Title Fiv', citation: 'Bruce Wayne5', comment: 'This is Batman\'s comment.', score: 5 }
  ]
  $scope.user = CurrentUser.data()
  user = $scope.user
  user.id = 1
  $scope.stars = [1,2,3,4,5]
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
]
