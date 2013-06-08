class UsersController < ApplicationController
  respond_to :json
  def index
    render json: User.all
  end

  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new
    user.update_attributes(params['user'])
    render json: user
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(params)
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.delete!
  end

  def ratings
    ratings = Rating.where('for_user_id = ?', params[:id]).all 
    render json: ratings
  end

  def errands
    #errands = Errand.joins([:user, :errand_requests]).where('errands.finished = true and errands.finished is not null and errand_requests.user_id = ?', params[:id]).all
    errands = Errand.joins([:user]).all
    render json: errands, :include => [:user]
  end
end
