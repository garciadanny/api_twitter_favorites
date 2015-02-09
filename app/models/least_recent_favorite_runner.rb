class LeastRecentFavoriteRunner < ActiveRecord::Base
  include FavoritesRunner

  def start
    15.times do
      favorites = fetch( { max_id: optimized_max_id } )
      persist_favorites( favorites )
      update_trackers( favorites )
      return if self.complete?
    end
    user.most_recent_favorite_runner.update( since_id: Favorite.first.twitter_id )
  end

  def update_trackers favorites
    user.most_recent_favorite_runner.update( since_id: Favorite.first.twitter_id ) if favorites.empty?
    self.update( complete: true ) if favorites.empty?
    self.update( max_id: favorites.last.id ) unless favorites.empty?
  end
end