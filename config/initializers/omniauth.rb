Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_FAVORITES_KEY'], ENV['TWITTER_FAVORITES_SECRET']
end