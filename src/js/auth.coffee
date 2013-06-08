module = angular.module 'tamad.auth', [

]

module.service 'CurrentUser', ['$http', 'Facebook', ($http, Facebook) ->
  data = {}
  service =
    data: -> data
    loggedIn: ->  data.facebook?
    # Load from localStorage
    load: -> 
      data = angular.fromJson(localStorage['userData']) ? {}
      Facebook.getLoginStatus().then (response) =>
        @loadData response.authResponse
      , (response) ->
        data.facebook = null      
    
    loadData: (authResponse) ->
      $http.get "https://graph.facebook.com/me?access_token=#{authResponse.accessToken}",
        withCredentials: false
      .success (fbData) =>
        console.log "success", fbData
        data.facebook = fbData
        service.save()
      .error (resp, status) ->
        console.error "Facebook responded", status, resp

    
    # Load from /api/session
    loadRemote: ->
      $http.get('/api/session').success (user) ->
        data = user
        service.save()
      .error (err) ->
#        data = {}
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
      CurrentUser.loadData response.authResponse
    , (error) ->
      console.log "error login", error
  $scope.logOut = ->
    Facebook.logout().then -> # session?
      $http.delete('/api/session').success (user) ->
        console.log "succes api sesion"
        CurrentUser.set {}
      .error (err) ->
        console.log 'Error!'
        CurrentUser.set {}
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
