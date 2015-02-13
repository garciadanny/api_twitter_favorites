class TwitterFavoritesJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.favorite_runner.start
    enqueue_next_job user
  end

  def enqueue_next_job user
    unless user.favorite_runner.complete?
      TwitterFavoritesJob.set(wait: 15.minutes).perform_later( user )
    end
  end
end