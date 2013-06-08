module = angular.module 'tamad.directives', [

]

module.directive 'rsErrand', -> {
  scope:
    errand: '='
    user: '=?'
    run: '&'
    action: '&'
    requests: '='
  template: '''
  <div class="errand">
    <img ng-src="{{errand.user.fb_id | photo}}"></img>
    <div class="title">{{ errand.title }}</div>
    <div class="price"><i class="icon-money"></i> PHP {{ errand.price | number:2 }}</div>
    <div class="location"><i class="icon-location-arrow"></i> {{ errand.location }}<span ng-show="user">  {{errand|distance:user}}</span></div>
    <div class="body">{{ errand.body }}</div>
    <button class="btn btn-success" ng-click="_run()" ng-show="user">Apply</button>
    <div ng-show="errand.errand_request_id">
      <div ng-repeat='request in requests'>
        <div ng-show="request.id == errand.errand_request_id">
          <div>You assigned {{request.user.first_name}} to do this task.</div>
          <button ng-show="request.finished" class="btn btn-success" ng-click="_action('acknowledge', request)">Acknowledge</button>
          <button ng-show="request.finished" class="btn btn-success" ng-click="_action('reject', request)">Reject</button>
          <button ng-hide="request.finished" class="btn btn-success" ng-click="_action('cancel', request)">Cancel</button>
        </div>
      </div>
    </div>
    <div ng-hide="errand.errand_request_id">
      <div ng-repeat='request in requests'>
        <div>User {{request.user.first_name}} wants to do this task.
          <!-- we don't all like inline styles :( -->
          <span style="color: red;" ng-show="request.declined">You declined.</span>
        </div>
        <button ng-hide="request.declined" class="btn btn-success" ng-click="_action('accept', request)">Accept</button>
        <button ng-hide="request.declined" class="btn btn-error" ng-click="_action('decline', request)">Decline</button>
        <button ng-show="request.declined" class="btn btn-info" ng-click="_action('undodecline', request)">Undo Decline</button>
      </div>
    </div>
  </div>
  '''
  link: (scope, element, attrs) ->
    scope._action = (name, request) ->
      scope.action errand: scope.errand, request: request, action: name
    scope._run = ->
      scope.run errand: scope.errand
  }
