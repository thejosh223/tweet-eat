module = angular.module 'tamad.payment', [

]

module.run ->
  Stripe.setPublishableKey('pk_test_m3g3aN0ozhShvEtA1IqyJHlC')
