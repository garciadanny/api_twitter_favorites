class Favorite < ActiveRecord::Base
  validates :twitter_id, uniqueness: {scope: :user_id}
  default_scope { order('created_at DESC') }

  def self.create_favorites tweet
    create! do |favorite|
      favorite.twitter_id = tweet.id
      favorite.text = tweet.text
    end
  end

  def unfavorite
    rest_client = RestClient.new(:twitter, user)
    rest_client.unfavorite( self.twitter_id )
    self.destroy
  end

  def user
    User.find(user_id)
  end
end