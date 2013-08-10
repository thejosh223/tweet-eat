class RestaurantsController < ApplicationController 
  def show
    make_vars
  end

  def make_comment
    Comment.create(:restaurant => params[:restaurant_name],
                   :date => DateTime.now,
                   :body => params[:body],
                   :author => params[:author])
    make_vars
    render :show
  end

  def index
    if params[:search]
      @restaurants = Restaurant.where(:name => /.*#{params[:search]}.*/i)
    else
      @restaurants = []
    end
  end

  def map
    @restaurants = Restaurant.all
  end

  private
  def make_vars
    @restaurant = Restaurant.find(params[:id])
    @comments = Comment.where(:restaurant => @restaurant.name)
    @words = Word.where(:restaurant => @restaurant.name)

    stopwords = ['ang', 'ng', 'na', 'sa', 'mga', 'at', 'the', 'to', 'yep', '', 'your', 'can', 'you', 'i', 'http', 't', 'co', 'com', 'twitter', 'isang', 'nyo', 'bash', 'louie', 'john', 'ramos', 'siguro', 'may', 'by', 'ako', 'ko', 'ikaw', 'ka', 'well', 'sexy', 'baby', 'helium', 'franchise', 'restaurant', 'how', 'now', 'mas', 'hahaha', 'with', 'and', 'dinner', 'rt', 'retweet', 'lang', 'pa', 'd', 'for', 'para', 'no', 'yung']

    # filter common words
    @words = @words.reject do |word|
      @restaurant.name.downcase.include? word.word or stopwords.include? word.word or word.word.length <= 2 or /\d/ =~ word.word
    end

    @words = @words.sort do |a, b|
      -a.weight <=> -b.weight
    end

    @words = @words[0...200]

    @tweets = Tweet.where(:restaurant => @restaurant.name).sort do |a, b|
      -a.followers <=> -b.followers
    end

    @tweets = @tweets[0..20].shuffle[0...5]
  end
end
