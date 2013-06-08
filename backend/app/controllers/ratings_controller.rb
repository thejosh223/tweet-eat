class RatingsController < ApplicationController
  def index
    render json: Rating.all
  end

  def show
    render json: Rating.find(params[:id])
  end
end
