module = angular.module 'tamad.directives', [

]

module.directive 'rsErrand', -> {
  scope:
    errand: '='
    user: '=?'
    run: '&'
    accept: '&'
    requests: '='
  template: '''
  <div class="errand">
    <img ng-src="{{errand.user.fb_id | photo}}"></img>
    <div class="title">{{ errand.title }}</div>
    <div class="price"><i class="icon-money"></i> PHP {{ errand.price | number:2 }}</div>
    <div class="location"><i class="icon-location-arrow"></i> {{ errand.location }}<span ng-show="user">  {{errand|distance:user}}</span></div>
    <div class="body">{{ errand.body }}</div>
    <button class="btn btn-success" ng-click="_run()" ng-show="user">Apply</button>
    <div ng-repeat='request in requests'>
      <div>User {{request.first_name}} {{request.last_name}} wants to do this task.</div>
      <button class="btn btn-success" ng-click="_accept(request)">Accept</button>
    </div>
  </div>
  '''
  link: (scope, element, attrs) ->
    scope._accept = (request) ->
      scope.accept errand: scope.errand, request: request
    scope._run = ->
      scope.run errand: scope.errand
}
