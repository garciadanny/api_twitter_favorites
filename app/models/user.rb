class User < ActiveRecord::Base
  has_one :least_recent_favorite_runner, dependent: :destroy
  has_one :most_recent_favorite_runner, dependent: :destroy
  has_many :favorites, dependent: :destroy

  after_create do |user|
    user.create_least_recent_favorite_runner
    user.create_most_recent_favorite_runner
  end

  def self.create_user auth
    create! do |user|
      user.twitter_id = auth['uid']
      user.twitter_handle = auth['info']['nickname']
      user.initial_favorites_count = auth['extra']['raw_info']['favourites_count']
      user.access_token = auth['credentials']['token']
      user.access_token_secret = auth['credentials']['secret']
    end
  end
end