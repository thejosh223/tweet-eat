"use strict"

module = angular.module 'tamad.facebook', [

]

module.value "FBAppId", "384016498385648"
module.value "FBAppSecret", "secret"

module.factory "FBObject", ['FBAppId', '$q', '$rootScope', (FBAppId, $q, $rootScope) ->
  FB = $q.defer()
  window.fbAsyncInit = ->
    console.log "async init fb"
    window.FB.init
      appId      : FBAppId, # App ID
      status     : true, # check login status
      cookie     : true, # enable cookies to allow the server to access the session
      xfbml      : true  # parse XFBML

    # Additional init code here
    $rootScope.$apply ->
      FB.resolve window.FB
  FB.promise
]

module.factory "Facebook", ['FBObject', '$q', '$rootScope', (FBObject, $q, $rootScope) ->

  # Load the SDK asynchronously
  do (d = document) ->
    id = 'facebook-jssdk'
    ref = d.getElementsByTagName('script')[0]
    if d.getElementById(id)
      return
    js = d.createElement('script')
    js.id = id
    js.async = true
    js.src = "//connect.facebook.net/en_US/all.js"
    ref.parentNode.insertBefore(js, ref)

  login: ->
    result = $q.defer()
    FBObject.then (FB) ->
      FB.getLoginStatus (statusResponse) ->
        if statusResponse.status == 'connected'
          result.resolve statusResponse
        else
          FB.login (status) ->
            $rootScope.$apply ->
              if status.authResponse
                result.resolve status
              else
                result.reject status

            # TODO move scope to somewhere better
          , scope: 'email'#,last_name,gender,age_range'
    result.promise

  getLoginStatus: ->
    result = $q.defer()  
    console.log "getting login status"
    FBObject.then (FB) ->
      console.log "got", FB
      FB.getLoginStatus (response) ->
        console.log "got 2", response
        $rootScope.$apply ->
          if response.authResponse
            result.resolve response
          else
            result.reject response
    result.promise
]
