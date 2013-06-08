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
    user.update_attributes(params.select {|k,v| safe_params.include? k })
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

  def safe_params
    ['first_name', 'last_name', 'location', 'latitude', 'longitude']
  end
end
