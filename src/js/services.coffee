module = angular.module 'tamad.services', [

]

module.factory 'Toastr', ($window) ->
  toastr = $window.toastr
  toastr.options.positionClass = 'toast-top-middle'
  toastr

module.factory 'NumberStream', ->
  seed = 0
  next: -> ++seed

module.factory 'currentBox', -> {}