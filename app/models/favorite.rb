class Favorite < ActiveRecord::Base

  def self.create_favorites tweet
    create! do |favorite|
      favorite.twitter_id = tweet.id
      favorite.text = tweet.text
    end
  end
end