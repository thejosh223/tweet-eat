module = angular.module 'tamad.payment', [
  'tamad.services'
]

module.controller 'TopUpCtrl', ($scope, $http, CurrentUser, currentBox, Toastr) ->
  $scope.cc = {}
  $scope.submit = ->
    $scope.cc.amount = +(((currentBox.errand.price - CurrentUser.data().credit) * 100).toFixed(0))
    $http.post("/api/users/#{CurrentUser.data().id}/top_up", $scope.cc, ->
      Toastr.success 'Successfully topped-up your wallet.'
      $('#credits-modal').modal('hide')
    , ->
      Toastr.error 'Failed to top up your wallet.'
      $('#credits-modal').modal('hide')
    )
