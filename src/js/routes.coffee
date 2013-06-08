module = angular.module "tamad.routes", [
]

module.config ["$routeProvider", ($routeProvider) ->

  $routeProvider.when "/",
    templateUrl: "/html/home.html"
    controller: 'HomeCtrl'

  $routeProvider.when "/my-errands",
    templateUrl: "/html/my-errands.html"
    controller: "MyErrandsCtrl"

  $routeProvider.when "/404",
    templateUrl: "/html/404.html"

  $routeProvider.when "/profile",
    templateUrl: "/html/profile.html"
    controller: "ProfileCtrl"

  $routeProvider.when "/profile/:id",
    templateUrl: "/html/public-profile.html"
    controller: "PublicProfileCtrl"

  $routeProvider.when "/accepted-errands",
    templateUrl: "/html/runner.html"
    controller: "AcceptedErrandsCtrl"
    
  $routeProvider.when "",
    redirectTo: "/"
  
  $routeProvider.otherwise redirectTo: "/404"
]
