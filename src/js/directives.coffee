module = angular.module 'tamad.directives', [

]

module.directive 'rsErrand', -> 
  scope:
    errand: '='
    user: '='
    run: '&'
    action: '&'
  template: '''
  <div class="errand">
    <div class="misc">
      <img ng-src="{{errand.user.fb_id | photo}}"></img>
      <button class="btn btn-success" ng-click="_run()" ng-show="user">Help Out</button>
      <div class="view-offers" ng-hide="user">
        <div class="offers-num" ng-show="errand.errand_requests.length > 0">{{ errand.errand_requests.length }}</div>
        <button class="btn btn-success view-offers-btn" ng-click="_view()" ng-hide="user">
          View Offers
        </button>
      </div>
    </div>
    <div class="desc">
      <div class="meta">
        <div class="title">{{ errand.title }}</div>
        <div class="name">{{ errand.user.first_name }} {{ errand.user.last_name }}</div>
        <div class="price">&#8369; {{ errand.price | number:2 }}</div>
        <div class="location">{{ errand.location }}<span ng-show="user">  {{errand|distance:user}}</span></div>
      </div>
      <div class="body">{{ errand.body }}</div>
    </div>
  </div>
  '''
  link: (scope, element, attrs) ->
    scope.showApply = attrs.showApply?
    scope.showManage = attrs.showManage?
    scope.showFinish = attrs.showFinish?
    scope._action = (name, request) ->
      scope.action errand: scope.errand, request: request, action: name
    scope._run = ->
      scope.run errand: scope.errand

