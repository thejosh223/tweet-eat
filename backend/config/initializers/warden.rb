Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :facebook
  manager.failure_app = SessionsController
end

Warden::Manager.serialize_into_session do |user| 
  user.id
end

Warden::Manager.serialize_from_session do |id| 
  User.find_by_id(id)
end

Warden::Strategies.add(:facebook) do
  def valid?
    params[:token]
  end

  def authenticate!
    puts "authenticating"
    response = HTTParty.get("https://graph.facebook.com/me?access_token=#{params[:token]}")

    if response['error']
      fail! response['error']['message']
    else
      user = User.where(:fb_id => response['id']).first
      if user
        token = params[:token]
        user.token = token
        user.save!
        success! user
      else
        fail! "Unable to login"
      end
    end
  end
end
