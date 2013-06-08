class ErrandRequestsController < ApplicationController
  def pending
    requests = ErrandRequest.joins(Errand.where("errand_request_id = ? AND user_id = ?", nil, current_user)).all
    render json: requests
  end
end
