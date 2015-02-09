module FavoritesRunner

  def fetch args
    params = args.delete_if { |k,v| v.nil? }
    client.favorites( {count: 200}.merge( params ) )
  end

  def persist_favorites favorites
    favorites.each { |f| user.favorites.create_favorites(f) }
  end

  def optimized_max_id
    max_id - 1 if max_id
  end

  def user
    @user ||= User.find user_id
  end

  def client
    @client ||= Twitter::REST::Client.new do |c|
      c.consumer_key = ENV['TWITTER_FAVORITES_KEY']
      c.consumer_secret = ENV['TWITTER_FAVORITES_SECRET']
      c.access_token = user.access_token # need to encrypt in db
      c.access_token_secret = user.access_token_secret # need to encrypt in db
    end
  end
end