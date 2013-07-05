class RestaurantsController < ApplicationController 
    def show
      @restaurant = Restaurant.find(params[:id])
      @comments = Comment.where(:restaurant_id => params[:id])
      @restaurantwords = RestaurantWord.find(:restaurant_id => params[:id])
      @tweets = Tweet.where(:restaurant_id => params[:id])
    end

    def index
      if params[:search]
        @restaurants = Restaurant.where(:name => /.*#{params[:search]}.*/i)
      else
        @restaurants = []
      end
    end
end
