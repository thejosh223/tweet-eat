"use strict"

module = angular.module 'tamad.facebook', [

]

module.value "FbAppId", "384016498385648"
module.value "FBAppSecret", "4f764641346a6e79c9c44b1c9b9a246a"

module.factory "Facebook", ['FbAppId', (FbAppId) ->
  window.fbAsyncInit = ->

      appId      : FbAppId, # App ID
      status     : true, # check login status
      cookie     : true, # enable cookies to allow the server to access the session
      xfbml      : true  # parse XFBML

    # Additional init code here

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

]
