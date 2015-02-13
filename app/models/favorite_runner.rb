class FavoriteRunner < ActiveRecord::Base
  include FavoritesRunnerHelper

  def start
    15.times do
      favorites = fetch( { max_id: optimized_max_id } )
      persist_favorites( favorites )
      update_trackers( favorites )
      return if self.complete?
    end
  end

  def update_trackers favorites
    self.update( complete: true ) if favorites.empty?
    self.update( max_id: nil) if favorites.empty?
    self.update( max_id: favorites.last.id ) unless favorites.empty?
    self.update( complete: false ) unless favorites.empty?
  end
end