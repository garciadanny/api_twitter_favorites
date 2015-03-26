module FavoritesRunnerHelper

  def fetch args
    params = args.delete_if { |k,v| v.nil? }
    client.favorites( {count: 200}.merge( params ) )
  end

  def persist_favorites favorites
    new_favs = new_favorites( favorites )
    new_favs.each { |f| user.favorites.create_favorites(f) }
  end

  def new_favorites favorites
    ids = favorites.map( &:id ) - Favorite.pluck( :twitter_id )
    favorites.select { |f| ids.include?( f.id ) }
  end

  def optimized_max_id
    max_id - 1 if max_id
  end

  def user
    @user ||= User.find user_id
  end

  def client
    @client ||= RestClient.new(:twitter, user)
  end
end