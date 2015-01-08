class TwitterFavoritesJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    # this will get called after #perform has finished
    # Check if there's more tweets to get and if so, call #perform 15 minutes from now
  end

  def perform(*args)
    # Do something later
  end
end
