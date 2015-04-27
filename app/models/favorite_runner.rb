class FavoriteRunner < ActiveRecord::Base
  include FavoritesRunnerHelper

  def start
    remaining_requests? ? perform_requests : perform_requests_later
  end

  def rate_limit_reset_time
    Time.at( client.rate_limit_status.reset )
  end

  private

  def perform_requests
    remaining_requests.times do
      favorites = fetch( { max_id: optimized_max_id } )
      persist_favorites( favorites )
      update_trackers( favorites )
      return if complete?
    end
  end

  def perform_requests_later
    TwitterFavoritesJob.set(wait_until: rate_limit_reset_time).perform_later( user )
    # TODO: how should we inform the user about having to wait?
  end

  def update_trackers favorites
    favorites.empty? ? reset_trackers : set_trackers(favorites)
  end

  def reset_trackers
    update( complete: true )
    update( max_id: nil )
  end

  def set_trackers favorites
    update( complete: false )
    update( max_id: favorites.last.id )
  end

  def remaining_requests
    client.rate_limit_status.remaining
  end

  def remaining_requests?
    remaining_requests > 0
  end
end