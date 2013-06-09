module = angular.module 'tamad.directives', [
  'tamad.resources'
]

module.directive 'rsErrand', (NumberStream, currentBox, $rootScope, Errand) -> 
  scope:
    errand: '='
    user: '='
    run: '&'
    action: '&'
  template: '''
  <div class="errand">
    <div class="misc">
      <img ng-src="{{errand.user.fb_id | photo}}"></img>
      <div class="name">{{ errand.user.first_name }} {{ errand.user.last_name }}</div>
      <button class="btn btn-success" ng-click="_run()" ng-show="showApply">Help Out</button>
      <div class="view-offers" ng-show="showManage && !errand.finished && !someFinished()">
        <div class="offers-num" ng-show="errand.errand_requests.length > 0">{{ errand.errand_requests.length }}</div>
        <button data-target="#offers-modal" ng-disabled="{{errand.errand_requests.length <= 0}}" data-toggle="modal" class="btn btn-success view-offers-btn" ng-click="_view()">
          View Offers
        </button>
      </div>
      <div class="accept-reject" ng-show="showManage && !errand.finished && someFinished()">
        <button class="btn btn-success mark-as-done-btn accept-btn" ng-click="_action('acknowledge')">
          Accept
        </button>
        <button class="btn btn-danger mark-as-done-btn reject-btn" ng-click="_action('reject')">
          Reject
        </button>
      </div>
      <div class="mark-as-done" ng-show="showFinish && !userRequest().finished">
        <button class="btn btn-success mark-as-done-btn" ng-click="_action('finish')">
          Mark as Done
        </button>
      </div>
      <div class="mark-as-done text-success" ng-show="showFinish && userRequest().finished && !errand.finished">
        You marked this task as completed.
      </div>
      <div class="mark-as-done text-success" ng-show="showFinish && userRequest().finished && errand.finished">
        You finished this task!
      </div>
    </div>
    <div class="desc">
      <div class="meta">
        <div class="title">{{ errand.title }}</div>
        <div class="distance" ng-user="user">{{errand | distance:user}}</div>
        <div class="location">{{ errand.location }}</div>
        <div class="price">&#8369; {{ errand.price | number:2 }}</div>
      </div>
      <div class="body">{{ errand.body }}</div>
    </div>
  </div>
  '''
  link: (scope, element, attrs) ->
    scope.showApply = attrs.showApply?
    scope.showManage = attrs.showManage?
    scope.showFinish = attrs.showFinish?
    scope.someFinished = ->
      _.some scope.errand.errand_requests, (request) -> request.finished
    scope.userRequest = ->
      _.find scope.errand.errand_requests, (request) -> request.user_id == scope.user.id
    scope._action = (name, request = scope.userRequest()) ->
      scope.action errand: scope.errand, request: request, action: name
    scope._run = ->
      scope.run errand: scope.errand
    scope._view = ->
      currentBox._action = scope._action
      currentBox.errand = scope.errand
      currentBox.id = scope.errand.id

    removeErrands = (request) -> _.omit request, ['errand']
    scope.$watch (-> 
      if errand?
        errand = _.extend {}, scope.errand
        errand.errand_requests = removeErrands(request) for request in errand.errand_requests
        errand
    ), ->
      if currentBox.id == scope.errand.id
        currentBox.errand = scope.errand
    , true

module.directive 'rsRating', -> 
  scope:
    request: '='
  template: '''
  <div class="rating-box">
    <div class="title">{{ request.errand.title }}</div>
    <div class="comment">{{ request.comment }}</div>
    <div class="pull-right muted">- {{ request.errand.user.first_name }} {{ request.errand.user.last_name }}</div>
    <div class="score">
      <span ng-repeat='star in stars' class='{{ {true: "icon-star", false: "icon-star-empty"}[star <= request.rating] }}'></span>
    </div>
    <div class='clearfix'></div>
  </div>
'''
  link: (scope, element, attrs) ->
    scope.stars = [1,2,3,4,5]
