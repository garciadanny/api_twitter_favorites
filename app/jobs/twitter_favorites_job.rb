class TwitterFavoritesJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    if user.least_recent_favorite_runner.complete?
      user.most_recent_favorite_runner.start
    else
      user.least_recent_favorite_runner.start
    end

    enqueue_next_job user
  end

  def enqueue_next_job user
    unless user.least_recent_favorite_runner.complete?
      TwitterFavoritesJob.set(wait: 15.minutes).perform_later( user )
    end
  end
end