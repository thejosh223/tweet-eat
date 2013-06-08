module = angular.module 'tamad.auth', [

]

module.service 'CurrentUser', ['$http', 'Facebook', 'User', '$q', ($http, Facebook, User, $q) ->
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
      loadResponse = $q.defer()
      $http.get "https://graph.facebook.com/me?access_token=#{authResponse.accessToken}",
        withCredentials: false
      .success (fbData) =>
        data.loggedIn = true
        _.extend data, fbData
        $http.post('/api/session',
          data
        ).success (resp) ->
          console.log "got user info", resp.user
          data = new User _.extend(data, resp.user)
          loadResponse.resolve resp.user
          service.save()
        .error (err) ->
          console.log "Failed (loadData)", err
          loadResponse.reject err
        service.save()
      .error (resp, status) ->
        console.error "Facebook responded", status, resp
        loadResponse.reject resp

      loadResponse.promise

    
    # Load from /api/session
    loadRemote: ->
      $http.get('/api/session').success (user) ->
        _.extend data, user
        service.save()
      .error (err) ->
        console.log "Failed (loadRemote)", err
        service.save()
    saveRemote: ->
      $http.put("/api/users/#{service.data().id}", service.data())
      service.save()
    set: (user) ->
      data = new User(user)
      service.save()
    save: -> localStorage['userData'] = angular.toJson(data)
  service.load()
  service
]

module.controller 'SessionCtrl', [
 '$scope', '$http', 'CurrentUser', 'Facebook', '$location', 'Toastr',
 ($scope, $http, CurrentUser, Facebook, $location, Toastr) ->
  $scope.CurrentUser = CurrentUser
  $scope.logIn = ->
    Facebook.login().then (response) ->
      Toastr.success 'Logged in successfully!'
      CurrentUser.loadData(response.authResponse).then (user) ->
        $scope.$broadcast 'login-changed'
    , (error) ->
      console.log "error login", error
      Toastr.error 'Something went wrong. Please try again.'
  $scope.logOut = ->
    Facebook.logout().then -> # session?
      $http.delete('/api/session').success (user) ->
        Toastr.success 'Logged out successfully!'
        CurrentUser.set {}
        $scope.$broadcast 'login-changed'
      .error (err) ->
        console.log 'Error!', err
        Toastr.error 'Something went wrong. Please try again.'
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
