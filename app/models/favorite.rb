class Favorite < ActiveRecord::Base
  validates :twitter_id, uniqueness: {scope: :user_id}
  default_scope { order('created_at DESC') }

  def self.create_favorites tweet
    create! do |favorite|
      favorite.twitter_id = tweet.id
      favorite.text = tweet.text
    end
  end
end