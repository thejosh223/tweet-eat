class ApplicationController < ActionController::Base
  protect_from_forgery
    def index
      @restaurants = Restaurant.search(params[:search])
    end
end
