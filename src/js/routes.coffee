module = angular.module "tamad.routes", [
]

module.config ["$routeProvider", ($routeProvider) ->

  $routeProvider.when "/",
    templateUrl: "/html/home.html"
    controller: "HomeCtrl"

  $routeProvider.when "/404",
    templateUrl: "/html/404.html"

  $routeProvider.when "/profile",
    templateUrl: "/html/profile.html"
    controller: "ProfileCtrl"
    
  $routeProvider.when "",
    redirectTo: "/"
  
  $routeProvider.otherwise redirectTo: "/404"
]
