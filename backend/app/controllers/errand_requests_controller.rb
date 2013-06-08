class ErrandRequestsController < ApplicationController
  def index
    requests = ErrandRequest.joins(:errand).where("(errands.finished is null or not errands.finished) AND errands.errand_request_id is not null AND errand_requests.user_id = ?", current_user.id).all
    render json: requests, :include => [:errand, :user]
  end
  def pending
    requests = ErrandRequest.joins(:errand).where("errands.user_id = ? AND ((errand_request_id is null and (errand_requests.declined is null or not errand_requests.declined)) OR (errand_request_id IS NOT NULL AND (errands.finished is null or not errands.finished) AND (errand_requests.finished is not null and errand_requests.finished)))", current_user.id).all
    render json: requests, :include => [:errand, :user]
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

  # will refactor this later :(
  def decline
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      request.declined = true
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def undodecline
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == current_user.id
      request.declined = false
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def reject
    request = ErrandRequest.find params[:id]
    if not request.nil? and (request.errand.user_id == current_user.id or request.user_id == current_user.id) # both can reject
      request.finished = false
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def finish
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.user_id == current_user.id # only user who owns request can mark as finished
      request.finished = true
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
end
