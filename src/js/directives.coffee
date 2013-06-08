module = angular.module 'tamad.directives', [

]

module.directive 'rsErrand', (NumberStream) -> 
  scope:
    errand: '='
    user: '='
    run: '&'
    action: '&'
  template: '''
  <div class="errand">
    <div class="misc">
      <img ng-src="{{errand.user.fb_id | photo}}"></img>
      <button class="btn btn-success" ng-click="_run()" ng-show="showApply">Help Out</button>
      <div class="view-offers" ng-show="showManage">
        <div class="offers-num" ng-show="errand.errand_requests.length > 0">{{ errand.errand_requests.length }}</div>
        <button data-target="#rs-errand-{{randId}}" data-toggle="modal" class="btn btn-success view-offers-btn" ng-click="_view()">
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
    <div id="rs-errand-{{randId}}" class="rs-errand-modal modal hide fade">
      <div class="modal-header">
        <button class="btn close" type="button" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Offers</h3>
      </div>
      <div class="modal-body">
        <ul class="modal-form">
          <li ng-repeat="request in errand.errand_requests" ng-show="request.id == errand.errand_request_id" class="row-fluid">
            <div class="span5">
              You assigned {{request.user.first_name}} to do this task.
              <span class="text-info" ng-show="request.finished && !errand.finished">{{ request.user.first_name}} marked this task as finished</span>
              <span class="text-success" ng-show="errand.finished">This task is finished</span>
            </div>
            <ul class="span5 buttons">
              <li><button ng-if="request.finished" class="btn btn-success" ng-click="_action('acknowledge', request)">Acknowledge</button></li>
              <li><button ng-if="request.finished" class="btn btn-error" ng-click="_action('reject', request)">Reject</button></li>
              <li><button ng-if="!request.finished" class="btn btn-info" ng-click="_action('cancel', request)">Cancel</button></li>
            </ul>
          </li>
          <li ng-repeat='request in errand.errand_requests' class="row-fluid">
            <div class="span5">
              Runner {{request.user.first_name}} wants to do this task.
              <span class="text-error" ng-show="request.declined">You declined.</span>
            </div>
            <ul class="span5 buttons">
              <li><button ng-if="!request.declined" class="btn btn-success" ng-click="_action('accept', request)">Accept</button></li>
              <li><button ng-if="!request.declined" class="btn btn-error" ng-click="_action('decline', request)">Decline</button></li>
              <li><button ng-if="request.declined" class="btn btn-info" ng-click="_action('undodecline', request)">Undo Decline</button></li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </div>
  '''
  link: (scope, element, attrs) ->
    scope.randId = NumberStream.next()
    scope.showApply = attrs.showApply?
    scope.showManage = attrs.showManage?
    scope.showFinish = attrs.showFinish?
    scope._action = (name, request) ->
      scope.action errand: scope.errand, request: request, action: name
    scope._run = ->
      scope.run errand: scope.errand
    scope._view = ->
      console.log "hey view"

