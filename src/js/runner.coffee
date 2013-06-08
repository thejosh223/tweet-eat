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

  $scope.$on 'reload-errands', (event) ->
    query()

  query()

  $scope.doAction = (action, errand, request) ->
    # add toastr here!!!!
    switch action
      when "finish"
        $http.put("/api/errand_requests/#{request.id}/finish").success (response) ->
          console.log "successfully finished", response
          $scope.$emit 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$emit 'reload-errands'

      when "reject"
        $http.put("/api/errand_requests/#{request.id}/reject").success (response) ->
          console.log "successfully rejected", response
          $scope.$emit 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$emit 'reload-errands'

