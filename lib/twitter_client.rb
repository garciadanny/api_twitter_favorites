module TwitterClient
  def client
    @client ||= Twitter::REST::Client.new do |c|
      c.consumer_key = ENV['TWITTER_FAVORITES_KEY']
      c.consumer_secret = ENV['TWITTER_FAVORITES_SECRET']
      c.access_token = user.access_token # need to encrypt in db
      c.access_token_secret = user.access_token_secret # need to encrypt in db
    end
  end
end