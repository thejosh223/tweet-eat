class SessionsController < ApplicationController
  respond_to :json

  def show
    if env['warden'].authenticated?
      render json: { ok: true, user: current_user.as_json }, status: :ok
    else
      # We'll actually never hit this place...
      render json: { :ok => false }, status: :unauthorized
    end
  end

  def create
    fb_id = params[:id]
    user = User.where(:fb_id => fb_id).first
    if user.nil?
      # create a new user
      user = User.new
      user.email = params[:email]
      user.password = "skdlfjdslkfjdslkfjslkXXjerwipfXXjipfdpjXXokdjcfpo;';'dmXXcdkopjfXXsdklXXf--=-=+hdosnqp1"
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.fb_id = fb_id
      user.save!
    else
      # we need to update info too
      user.email = params[:email] or user.email
      user.first_name = params[:first_name] or user.first_name
      user.last_name = params[:last_name] user.last_name
      user.save!
    end
    puts env['warden'].user
    env['warden'].set_user user
    puts env['warden'].user
    render json: { :ok => true, :user => user.as_json }, status: :ok
  end

  def update
    env['warden'].authenticate!
    render json: { :ok => true, :user => current_user.as_json }, status: :ok
  end

  def destroy
    env['warden'].logout
    render json: { :ok => false, :message => "Logged out"}, status: :ok
  end

  def unauthenticated()
    render json: { :ok => false, :error  => (env['warden'].message || "Unauthenticated or unable to authenticate") }, status: :unauthorized
  end
end
