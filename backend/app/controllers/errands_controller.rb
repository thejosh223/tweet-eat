class ErrandsController < ApplicationController
  respond_to :json

  def index
     if env['warden'].authenticated?
        render json: Errand.where(:user => current_user).all
     else
        render json: '', status: :unauthorized
     end
  end

  def show
     if env['warden'].authenticated?
	render json: Errand.find(params[:id])
     else
        render json: '', status: :unauthorized
     end
  end

  def create
     if env['warden'].authenticated?
        errand = Errand.new
        errand.title = params[:title]
        errand.body = params[:body]
        errand.deadline = params[:deadline]
        errand.price = params[:price]
        errand.user = current_user
        errand.save!
	render json: errand
     else
        render json: '', status: :unauthorized
     end
  end

  def update
    env['warden'].authenticate!
    render json: { :ok => true, :user => current_user.as_json }, status: :ok
  end

  def destroy
    env['warden'].logout
    render json: { :ok => false, :message => "Logged out"}, status: :ok
  end
end
