"use strict"

module = angular.module 'tamad.auth', [

]

module.service 'CurrentUser', ['$http', ($http) ->
  data = null
  service =
    data: -> data
    loggedIn: -> false # for now
    # Load from localStorage
    load: -> data = angular.fromJson(localStorage['userData']) ? {}
    # Load from /api/session
    loadRemote: ->
      $http.get('/api/session').success (user) ->
        data = user
        service.save()
      .error (err) ->
        data = null
        service.save()
    set: (user) ->
      data = user
      service.save()
    save: -> localStorage['userData'] = angular.toJson(data)
  service.load()
  service
]

module.controller 'SessionCtrl', [
 '$scope', '$http', 'CurrentUser', 'Facebook', 
 ($scope, $http, CurrentUser, Facebook) ->
  $scope.CurrentUser = CurrentUser
  $scope.logIn = ->
    Facebook.login().then (response) ->
      console.log "success login", response
    , (error) ->
      console.log "error login", error
  $scope.logOut = ->
    $http.delete('/api/session').success (user) ->
      console.log 'Success'
      CurrentUser.set null
    .error (err) ->
      console.log 'Error!'
      CurrentUser.set null
  $scope.signUp = ->
    console.log "Sign up!!!"
    # With facebook
  CurrentUser.loadRemote()
]

module.value 'PublicRoutes', [
  '/home'
  '/'
  ''
  '/404'
]

module.run [
 '$rootScope', '$location', 'CurrentUser', 'PublicRoutes', 
 ($rootScope, $location, CurrentUser, PublicRoutes) ->
  $rootScope.$on '$routeChangeStart', ->
    if not CurrentUser.loggedIn() and $location.path() not in PublicRoutes
      # redirect path
      $location.path '/'
    
]