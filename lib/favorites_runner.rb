class FavoritesRunner
  attr_reader :user

  def initialize user
    @user = user
  end

  def start
    15.times do
      f = fetch
      persist_favorites( f )
      update_last_fetched_favorite( f )
    end
  end

  private

  def update_last_fetched_favorite favorites
    user.last_fetched_favorite.update( favorite_id: favorites.last.id ) if favorites.last
    user.last_fetched_favorite.update( last_favorite: true ) if favorites.count < 200
  end

  def persist_favorites favorites
    favorites.shift unless user.new_user?
    favorites.each { |f| user.favorites.create_favorites(f) }
  end

  def fetch
    max_id = user.last_fetched_favorite.favorite_id
    args = { count: 200, max_id: max_id }.delete_if { |k,v| v.nil? }
    client.favorites( args )
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