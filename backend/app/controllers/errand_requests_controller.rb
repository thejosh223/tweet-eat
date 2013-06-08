class ErrandRequestsController < ApplicationController
  def index
    requests = ErrandRequest.joins(:errand).where("not errands.finished AND errand_requests.user_id = ?", current_user.id).all
    render json: requests
  end
  def pending
    requests = ErrandRequest.joins(Errand.where("errand_request_id = ? AND user_id = ?", nil, current_user.id)).all
    render json: requests
  end
end
