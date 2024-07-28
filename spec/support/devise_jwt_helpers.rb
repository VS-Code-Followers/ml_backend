module DeviseJwtHelpers
  def generate_jwt_token(user)
    exp = 24.hours.from_now.to_i
    payload = { user_id: user.id, exp: }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key)
  end
end
