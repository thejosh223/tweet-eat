"use strict"

module = angular.module 'tamad.resources', [

]

module.factory 'Errand', ['$resource', ($resource) ->
  $resource '/api/errands/:id'
]

module.factory 'User', ['$resource', ($resource) ->
  $resource '/api/users/:id'
]
