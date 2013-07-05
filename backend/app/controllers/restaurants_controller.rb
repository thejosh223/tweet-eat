class RestaurantsController < ApplicationController 
    def show
      @restaurant = Restaurant.find(params[:id])
      @words = Word.where(:restaurant => @restaurant.name)

      # filter common words
      @words = @words.reject do |word|
        @restaurant.name.downcase.include? word.word or ['ang', 'ng', 'na', 'sa', 'mga', 'at', 'the', 'to', 'yep', '', 'your', 'can', 'you', 'i', 'http', 't', 'co', 'com', 'twitter', 'isang', 'nyo', 'bash', 'louie', 'john', 'ramos', 'siguro', 'may', 'by', 'ako', 'ko', 'ikaw', 'ka', 'well', 'sexy', 'baby', 'helium', 'franchise', 'restaurant', 'how', 'now', 'mas', 'hahaha', 'with', 'and', 'dinner', 'rt', 'retweet', 'lang', 'pa', 'd', 'for', 'para', 'no'].include? word.word
      end

      @words = @words.sort do |a, b|
        -a.weight <=> -b.weight
      end

      @words = @words[0...200]

      @tweets = Tweet.where(:restaurant => @restaurant.name).sort do |a, b|
        -a.followers <=> -b.followers
      end
      
      @tweets = @tweets[0..5]
    end

    def index
      if params[:search]
        @restaurants = Restaurant.where(:name => /.*#{params[:search]}.*/i)
      else
        @restaurants = []
      end
    end
end
