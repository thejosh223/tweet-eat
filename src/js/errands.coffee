module = angular.module 'tamad.errands', [
  'tamad.resources'
]


module.controller 'MyErrandsCtrl', ($scope, $http) ->
  query = ->
    $http.get("/api/errands/mine").success (errands) ->
      $scope.errands = errands
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
      when "accept" # you want this runner to do your task
        $http.put("/api/errand_requests/#{request.id}").success (response) ->
          console.log "successfully accepted", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'
      when "decline" # you don't want this runner to do your task
        $http.put("/api/errand_requests/#{request.id}/decline").success (response) ->
          console.log "successfully decline", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'
      when "undodecline" # undo 'decline' of a runner
        $http.put("/api/errand_requests/#{request.id}/undodecline").success (response) ->
          console.log "successfully undid decline", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'
      when "cancel" # cancel the errand given to runner 
        $http.put("/api/errands/#{errand.id}/cancel").success (response) ->
          console.log "successfully cancelled", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'
      when "reject" # runner did not really complete errand
        $http.put("/api/errand_requests/#{request.id}/reject").success (response) ->
          console.log "successfully cancelled", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'
      when "acknowledge" # acknowledge that runner has indeed completed errand
        $http.put("/api/errands/#{request.id}/acknowledge").success (response) ->
          console.log "successfully acknowledged", response
          $scope.$broadcast 'reload-errands'
        .error (response) ->
          console.error "for some reason it failed", response
          $scope.$broadcast 'reload-errands'



module.controller 'ErrandCreationCtrl', ($scope, CurrentUser, Errand, $location) ->
  $scope.errand =
    deadline: null
    location: CurrentUser.data()?.location
  isDefault = not CurrentUser.data()?.latitude?
  lat = CurrentUser.data()?.latitude ? 14.566
  long = CurrentUser.data()?.longitude ? 121.034
  zoomLevel = if isDefault then 11 else 14
  $scope.$watch (-> $('#new-errand').is(':visible')), (vis) ->
    if vis
      $('#location-map-wrapper').empty().append('<div id="location-map">')
      map = L.map('location-map').setView([lat, long], zoomLevel)
      L.tileLayer('http://b.tile.cloudmade.com/bce295a2a50d43a2bb2dbebef4ea99e4/4/256/{z}/{x}/{y}.png', {
          attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="http://cloudmade.com">CloudMade</a>',
          maxZoom: 18
      }).addTo(map)

      popup = L.marker()
      if not isDefault
        popup.setLatLng(new L.LatLng(lat, long)).addTo(map)
      map.on 'click', (e) ->
        if e.latlng?
          popup.setLatLng(e.latlng).addTo(map)
          $scope.errand.latitude = e.latlng.lat
          $scope.errand.longitude = e.latlng.lng
       
  $scope.today = new Date()


  $scope.submit = ->
    unless $scope.errand?.latitude?
      Toastr.error 'Please click on the map to mark where your errand is to be done.'
      return false
    # save $scope.errand.latitude/longitude to user
    Errand.save $scope.errand, (success) ->
      $scope.$broadcast 'reload-errands'
      $location.path('/my-errands')
      $('#new-errand').modal('hide')


module.controller 'LocationSetCtrl', ($scope, CurrentUser) ->
  isDefault = not CurrentUser.data()?.latitude?
  lat = CurrentUser.data()?.latitude ? 14.566
  long = CurrentUser.data()?.longitude ? 121.034
  zoomLevel = if isDefault then 11 else 14
  $scope.$watch (-> $('#set-location-wrapper').is(':visible')), (vis) ->
    console.log vis, 'Vis change!'
    if vis
      $('#set-location-wrapper').empty().append('<div id="set-location">')
      map = L.map('set-location').setView([lat, long], zoomLevel)
      L.tileLayer('http://b.tile.cloudmade.com/bce295a2a50d43a2bb2dbebef4ea99e4/4/256/{z}/{x}/{y}.png', {
          attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="http://cloudmade.com">CloudMade</a>',
          maxZoom: 18
      }).addTo(map)

      popup = L.marker()
      if not isDefault
        popup.setLatLng(new L.LatLng(lat, long)).addTo(map)
      map.on 'click', (e) ->
        if e.latlng?
          popup.setLatLng(e.latlng).addTo(map)
          CurrentUser.data()?.latitude = e.latlng.lat
          CurrentUser.data()?.longitude = e.latlng.lng

  $scope.setLocation = ->
    unless CurrentUser.data()?.latitude?
      Toastr.error 'Please click on the map to mark where you want to search for errands.'
    CurrentUser.saveRemote()
    $('#set-location-modal').modal('hide')
