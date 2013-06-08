module = angular.module 'tamad.auth', [

]

module.service 'CurrentUser', ['$http', 'Facebook', 'User', ($http, Facebook, User) ->
  data = {}
  service =
    data: -> data
    loggedIn: -> data.loggedIn
    # Load from localStorage
    load: -> 
      data = new User(angular.fromJson(localStorage['userData']) ? {})
      Facebook.getLoginStatus().then (response) =>
        @loadData response.authResponse
      , (response) ->
        data.loggedIn = false     
        service.save()
    
    loadData: (authResponse) ->
      $http.get "https://graph.facebook.com/me?access_token=#{authResponse.accessToken}",
        withCredentials: false
      .success (fbData) =>
        console.log "success", fbData
        data.loggedIn = true
        _.extend data, fbData
        $http.post('/api/session',
          data
        ).success (user) ->
          console.log "got user info", user
          data = new User _.extend(data, user)
        .error (err) ->
          console.log "Failed (loadData)", err
        service.save()
      .error (resp, status) ->
        console.error "Facebook responded", status, resp

    
    # Load from /api/session
    loadRemote: ->
      $http.get('/api/session').success (user) ->
        _.extend data, user
        service.save()
      .error (err) ->
        console.log "Failed (loadRemote)", err
        service.save()
    set: (user) ->
      data = new User(user)
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

module.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.withCredentials = true
]
