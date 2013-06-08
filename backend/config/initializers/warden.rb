Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :email, :facebook
  manager.failure_app = SessionsController
end


Warden::Manager.serialize_into_session { |user| user.id             }
Warden::Manager.serialize_from_session { |id  | User.find_by_id(id) }

Warden::Strategies.add(:facebook) do
  def valid?
    ('facebook' == params[:provider]) && params[:token]
  end

  def authenticate!
    response = HTTParty.get("https://graph.facebook.com/me?access_token=#{params[:token]}")

    if response['error']
      fail!(response['error']['message'])
    else
      user = User.find_by_uid(response['id'])
      if user
        token = params[:token]
        # Try to exchange the token for an extended one; if that fails, just
        # keep using the short-lived token.
        token = exchange_for_extended(token) || token
        user.token = token
        user.save!(validate: false) # no validation, in case the mobile number is invalid
        success!(user)
      else
        fail!("Unable to login via Facebook")
      end
    end
  end

  # Exchanges a short-lived token for an extended one; see
  # https://developers.facebook.com/docs/howtos/login/extending-tokens/.
  def exchange_for_extended(token)
    response = HTTParty.get(
      'https://graph.facebook.com/oauth/access_token',
      {query: {
        grant_type: 'fb_exchange_token',
        client_id: FacebookCredentials::APP_ID,
        client_secret: FacebookCredentials::APP_SECRET,
        fb_exchange_token: token
      }}
    )
    if response.code == 200
      logger.info 'Exchanged Facebook token for a long-lived one.'
      # The response body is a URL-query-like string, e.g.
      # "access_token=AAAIeue&expires=5184000" (although the token is typically
      # much longer).
      parsed_body = Rack::Utils::parse_query(response.body)
      parsed_body['access_token']
    else
      logger.warn "Failed to exchange Facebook token for a long-lived one; got response #{response}"
      nil
    end
  end
end

      # args = {
      #   "provider"   => 'facebook',
      #   'uid'        => response['id'],
      #   'first_name' => response['first_name'],
      #   'last_name'  => response['last_name'],
      #   'email'      => response['email'],
      #   '_facebook'  => response
      # }
      # user = User.create_or_retrieve(args)

      # success!(user) if  user.valid?
      # fail!(user)    if !user.valid?
