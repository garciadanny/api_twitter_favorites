class MostRecentFavoriteRunner < ActiveRecord::Base
  include FavoritesRunner

  def start
    15.times do |counter|
      favorites = fetch( { since_id: since_id, max_id: optimized_max_id } )
      persist_favorites( favorites )
      update_trackers( favorites, counter )
      return if favorites.empty?
    end
  end

  def update_trackers favorites, counter
    # If it's our first time issuing requests (counter == 1) and the response is empty
    # We don't want to change the `since_id`, just in case the user deleted the most
    # recent favorite before requesting for newer favorites.
    # If the counter is greater than 1, and the response is empty, that tells us
    # that we got new favorites in the previous request and should now update the
    # `since_id'.` We add 1 to the counter since Integer#times starts at 0.
    counter += 1
    self.update( max_id: favorites.last.id ) unless favorites.empty?
    self.update( max_id: nil ) if favorites.empty?
    self.update( since_id: Favorite.first.twitter_id ) if favorites.empty? && counter > 1
  end
end