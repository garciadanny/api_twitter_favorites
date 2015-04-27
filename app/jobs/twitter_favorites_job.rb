class TwitterFavoritesJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    favorite_runner.start
    enqueue_next_job
  end

  def enqueue_next_job
    unless favorite_runner.complete?
      time = favorite_runner.rate_limit_reset_time
      TwitterFavoritesJob.set(wait_until: time).perform_later( user )
    end
  end

  def user
    @user ||= arguments.first
  end

  def favorite_runner
    @runner ||= FavoriteRunner.find_by( user_id: user.id )
  end
end