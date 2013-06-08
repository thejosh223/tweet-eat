class ErrandsController < ApplicationController
  respond_to :json
  def index
    #render json: Errand.where(:user => current_user).all
    render json: Errand.all
  end

  def show
    render json: Errand.find(params[:id])
  end

  def create
    errand = Errand.new
    errand.title = params[:title]
    errand.body = params[:body]
    errand.deadline = params[:deadline]
    errand.price = params[:price]
    #errand.user = current_user
    errand.save!
    render json: errand
  end

  def update
    errand = Errand.find(params[:id])
    errand.title = params[:title]
    errand.body = params[:body]
    errand.deadline = params[:deadline]
    errand.price = params[:price]
    #errand.user = current_user
    errand.save!
    render json: errand
  end

  def destroy
    errand = Errand.find(params[:id])
    errand.delete!
  end
end
