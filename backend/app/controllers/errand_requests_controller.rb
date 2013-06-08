class ErrandRequestsController < ApplicationController
  def index
    unless env['warden'].user.nil?
      requests = ErrandRequest.joins(:errand).where("(errands.finished is null or not errands.finished) AND errands.errand_request_id is not null AND errand_requests.user_id = ?", env['warden'].user.id).all
      render json: requests, :include => [:errand, :user]
    else
      render json: {}, status: :unprocessable_entity
    end
  end
  def pending
    unless env['warden'].user.nil?
      requests = ErrandRequest.joins(:errand).where("errands.user_id = ? AND ((errand_request_id is null and (errand_requests.declined is null or not errand_requests.declined)) OR (errand_request_id IS NOT NULL AND (errands.finished is null or not errands.finished) AND (errand_requests.finished is not null and errand_requests.finished)))", env['warden'].user.id).all
      render json: requests, :include => [:errand, :user]
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == env['warden'].user.id
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
    if not request.nil? and request.errand.user_id == env['warden'].user.id
      request.declined = true
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def undodecline
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.errand.user_id == env['warden'].user.id
      request.declined = false
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def reject
    request = ErrandRequest.find params[:id]
    if not request.nil? and (request.errand.user_id == env['warden'].user.id or request.user_id == env['warden'].user.id) # both can reject
      request.finished = false
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
  def finish
    request = ErrandRequest.find params[:id]
    if not request.nil? and request.user_id == env['warden'].user.id # only user who owns request can mark as finished
      request.finished = true
      request.save!
      render json: {ok: true}
    else
      render json: "", status: 404
    end
  end
end
