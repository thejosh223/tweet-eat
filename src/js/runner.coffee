"use strict"

module = angular.module 'tamad.runner', [

]

module.controller 'AcceptedErrandsCtrl', ($scope, $http) ->

  query = ->
    $http.get('/api/errand_requests').success (requests) ->
      $scope.requests = requests
      $scope.errands = for request in requests
        request.errand.errand_requests = [request]
        request.errand
      $scope.$broadcast 'reload-box-trigger'
    .error (error) ->
      console.error "error getting errands", error
      $scope.$broadcast 'reload-box-trigger'

  $scope.$on 'reload-errands', (event) ->
    query()

  query()

  $scope.doAction = (action, errand, request) ->
    # add toastr here!!!!
    switch action
      when "finish"
        $http.put("/api/errand_requests/#{request.id}/finish").success (response) ->
          console.log "successfully finished", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'

      when "reject"
        $http.put("/api/errand_requests/#{request.id}/reject").success (response) ->
          console.log "successfully rejected", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'
