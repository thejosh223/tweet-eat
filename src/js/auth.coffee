module = angular.module 'tamad.auth', [
  'tamad.services'
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
          loadResponse.resolve [resp.user, resp.new]
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
 '$scope', '$http', 'CurrentUser', 'Facebook', '$location', 'Toastr', 'currentBox', '$rootScope',
 ($scope, $http, CurrentUser, Facebook, $location, Toastr, currentBox, $rootScope) ->
  $scope.CurrentUser = CurrentUser
  $scope.currentBox = currentBox
  $scope.logIn = ->
    Facebook.login().then (response) ->
      Toastr.success 'Logged in successfully!'
      CurrentUser.loadData(response.authResponse).then ([user, is_new]) ->
        console.log user, is_new
        if is_new
          console.log 'showing'
          $('#verification-code-modal').modal('show')

        $location.path '/'
        $scope.$broadcast 'login-changed'
    , (error) ->
      console.log "error login", error
      Toastr.error 'Something went wrong. Please try again.'
  $scope.logOut = ->
    Facebook.logout().then -> # session?
      $http.delete('/api/session').success (user) ->
        Toastr.success 'Logged out successfully!'
        CurrentUser.set {}
        $location.path '/'
        $scope.$broadcast 'login-changed'
      .error (err) ->
        console.log 'Error!', err
        Toastr.error 'Something went wrong. Please try again.'
        CurrentUser.set {}

  $scope.closeRatings = ->
    $("#ratings-modal").modal 'hide'

  CurrentUser.loadRemote()
]

module.controller 'VerificationModalCtrl', ($scope, CurrentUser) ->
  $scope.verification_code = CurrentUser.data().verification_code
  $scope.submit = ->
    CurrentUser.data().phone_number = $scope.phone_number
    CurrentUser.saveRemote()
    $('#verification-code-modal').modal('hide')

module.value 'PublicRoutes', [
  '/home'
  '/'
  ''
  '/404'
  '/profile'
]

module.run [
 '$rootScope', '$location', 'CurrentUser', 'PublicRoutes', 
 ($rootScope, $location, CurrentUser, PublicRoutes) ->
  $rootScope.$on '$routeChangeStart', ->
    if not CurrentUser.loggedIn() and _.some(PublicRoutes, (route) -> $location.path().indexOf(route) == 0)
      # redirect path
      $location.path '/'
    
]

module.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.withCredentials = true
]
