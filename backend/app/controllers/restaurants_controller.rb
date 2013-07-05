class RestaurantsController < ApplicationController 
    def show
      @restaurant = Restaurant.find(params[:id])
      @comments = Comment.where(:restaurant_id => :id)
      @restaurantwords = RestaurantWord.where(:restaurant_id => :id)
      @tweets = Tweet.where(:restaurant_id => :id)
    end

    def index
      @restaurants = Restaurant.search(params[:search])
    end
end