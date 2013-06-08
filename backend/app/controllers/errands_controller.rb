class ErrandsController < ApplicationController
  respond_to :json
  def index
    #render json: Errand.where(:user => env['warden'].user).all
    @errands = Errand.includes(:user).select("*, users.fb_id").all

    long = lat = nil
    if params['longitude']
      long = params['longitude'].to_f
      lat = params['latitude'].to_f
    elsif env['warden'].user and env['warden'].user.longitude
      long = env['warden'].user.longitude
      lat = env['warden'].user.latitude
    end

    if long
      @errands = @errands.sort_by {|x| x.distance_to([lat, long]) }
    end

    render json: @errands
  end

  def show
    render json: Errand.includes(:user).select("*, users.fb_id").find(params[:id])
  end

  def create
    errand = Errand.new
    unless env['warden'].user.nil?
      errand.user_id = env['warden'].user.id
    end


    if not current_user.nil? and current_user.location.nil?
      current_user.location = params['location']
      current_user.longitude = params['longitude'].to_f
      current_user.latitude = params['latitude'].to_f
    end

    errand.update_attributes(params['errand'])
    puts "UIx:"
    puts env['warden'].user
    puts "UIy:"
    render json: errand
  end

  def update
    errand = Errand.find(params[:id])
    errand.update_attributes(params)
    render json: errand
  end

  def destroy
    errand = Errand.find(params[:id])
    errand.delete!
  end

  def mine
    # Gives all the errands you own
    @errands = Errand.includes([:user, :errand_requests]).select("*, users.fb_id").where('errands.user_id = ?', current_user.id).all
    render json: @errands
  end

  def apply
    old = ErrandRequest.find('errand_id = ? AND user_id = ?', params[:id], current_user.id)
    if !old.nil?
      render json: old
    else
      request = ErrandRequest.new
      request.update_attributes(params)
      request.errand_id = params[:id] 
      request.user_id = current_user.id
      request.save!
      render json: request
    end
  end

  def accepted
    errands = Errand.joins(:errand_requests).where('Errands.user_id = ? AND Errands.finished != true', current_user.id)
    render json: errands
  end
end
