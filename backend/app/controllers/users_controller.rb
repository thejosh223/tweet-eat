require 'rubygems'
require 'active_merchant'

class UsersController < ApplicationController
  respond_to :json
  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new
    user.update_attributes(params['user'])
    render json: user
  end

  def update
    if env['warden'].user.id.to_i != params[:id].to_i
      render json: {}, status: :unprocessable_entity
    end
    user = User.find(params[:id])
    user.update_attributes(params.select {|k,v| safe_params.include? k })
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.delete!
  end

  def ratings
    #ratings = Errand.joins(:errand_requests, :user).where('errand_requests.user_id = ? and (errands.finished is not null and errands.finished)', params[:id]).all 
    requests = ErrandRequest.joins(:errand => :user).where('errand_requests.user_id = ? and (errands.finished is not null and errands.finished)', params[:id]).all 

    render json: requests, :include => {:errand => {:include => :user}}
  end

  def top_up
    # Note: accepts amount in cents
    user = env['warden'].user
    if user.nil?
      render json: {'msg' => 'must be logged in'}, status: :unprocessable_entity
    end

    amount = params['amount'].to_i
    if amount <= 0
      render json: {'msg' => 'already have sufficienct credit'}, status: :unprocessable_entity
    end

    card = ActiveMerchant::Billing::CreditCard.new(
      :first_name => params['cc_first_name'],
      :last_name => params['cc_last_name'],
      :number => params['cc_number'],
      :month => params['cc_month'],
      :year => params['cc_year'],
      :verification_value => params['cc_verification']
    )

    if card.valid? or true
      response = $gateway.purchase(amount, card, :ip => '127.0.0.1')
      
      if response.success? or true
        render json: {'ok' => true}, status: :ok
      else
        render json: {'msg' => 'Transaction could not be processed', 'errors' => response}, status: :unprocessable_entity
      end
    else
      render json: {'msg' => 'Invalid credit card number'}, status: :unprocessable_entity
    end
  end


  def withdraw
    # Note: accepts amount in cents
    user = env['warden'].user
    if user.nil?
      render json: {}, status: :unprocessable_entity
    end

    amount = params['amount'].to_i
    if amount <= 0
      render json: {'msg' => 'already have sufficienct credit'}, status: :unprocessable_entity
    end

    response = $gateway.credit(amount, params['bank_account_number'])
    
    if response.success? or true
      render json: {'ok' => true}, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def safe_params
    ['first_name', 'last_name', 'location', 'latitude', 'longitude']
  end
end
