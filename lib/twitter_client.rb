class TwitterClient
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def favorites(options)
    client.favorites(options)
  end

  def unfavorite(twitter_id)
    client.unfavorite(twitter_id)
  end


  def rate_limit_status
    response = request.perform
    status = response[:resources][:favorites][:"/favorites/list"]
    OpenStruct.new( status )
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |c|
      c.consumer_key = ENV['TWITTER_FAVORITES_KEY']
      c.consumer_secret = ENV['TWITTER_FAVORITES_SECRET']
      c.access_token = user.access_token # need to encrypt in db
      c.access_token_secret = user.access_token_secret # need to encrypt in db
    end
  end

  def request
    @req ||= Twitter::REST::Request.new(
      client,
      :get,
      '/1.1/application/rate_limit_status.json',
      {resources: 'favorites'}
    )
  end
end