module = angular.module 'tamad.services', [

]

module.factory 'Toastr', ($window) ->
  toastr = $window.toastr
  toastr.options.positionClass = 'toast-top-middle'
  toastr

