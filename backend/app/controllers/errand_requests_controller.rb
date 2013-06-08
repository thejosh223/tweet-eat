class ErrandRequestsController < ApplicationController
  def index
    requests = ErrandRequest.joins(:errand).where("(errands.finished is null or not errands.finished) AND errand_requests.user_id = ?", current_user.id).all
    render json: requests
  end
  def update
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      errand = request.errand
      errand.errand_request_id = request.id
      errand.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def pending
    requests = ErrandRequest.joins(:errand).where("errand_request_id = ? AND errands.user_id = ?", nil, current_user.id).all
    render json: requests
  end
end
