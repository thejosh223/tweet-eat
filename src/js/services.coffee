module = angular.module 'tamad.services', [

]

module.factory 'Notify', ($window) ->
  toastr = $window.toastr
  toastr.options.positionClass = 'toast-top-middle'
  toastr

