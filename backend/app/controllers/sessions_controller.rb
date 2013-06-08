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
