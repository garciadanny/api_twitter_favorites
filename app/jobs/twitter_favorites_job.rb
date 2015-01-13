class TwitterFavoritesJob < ActiveJob::Base
  queue_as :default

  def perform(runner_class, user)
    favorites_runner = runner_class.constantize.new( user )
    favorites_runner.start unless user.last_fetched_favorite.last_favorite?
    enqueue_next_job user
  end

  def enqueue_next_job user
    unless user.last_fetched_favorite.last_favorite?
      TwitterFavoritesJob.set(wait: 15.minutes).perform_later( 'FavoritesRunner', user )
    end
  end
end


