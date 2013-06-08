class ErrandsController < ApplicationController
  respond_to :json
  def index
    #render json: Errand.where(:user => current_user).all
    @errands = Errand.joins(:user).select("*, users.fb_id").all

    long = lat = nil
    if params['longitude']
      long = params['longitude'].to_f
      lat = params['latitude'].to_f
    elsif warden.user and warden.user.longitude
      long = warden.user.longitude
      lat = warden.user.latitude
    end

    if long
      @errands = @errands.sort_by {|x| x.distance_to([lat, long]) }
    end

    render json: @errands
  end

  def show
    render json: Errand.joins(:user).select("*, users.fb_id").find(params[:id])
  end

  def create
    errand = Errand.new
    if not current_user.nil?
      errand.user_id = current_user.id
    end


    if current_user.location.nil?
      current_user.location = params['location']
      current_user.longitude = params['longitude'].to_f
      current_user.latitude = params['latitude'].to_f
    end

    errand.update_attributes(params['errand'])
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
end
