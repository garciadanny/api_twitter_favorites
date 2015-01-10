class User < ActiveRecord::Base
  has_one :last_fetched_favorite

  after_initialize do
    last_fetched_favorite ||= build_last_fetched_favorite
  end

  def self.create_user auth
    create! do |user|
      user.twitter_id = auth['uid']
      user.twitter_handle = auth['info']['nickname']
      user.initial_favorites_count = auth['extra']['raw_info']['favourites_count']
    end
  end

  def update_token auth
    self.update access_token: auth['credentials']['token']
    self.update access_token_secret: auth['credentials']['secret']
  end

  def new_user?
    user.last_fetched_favorite.favorite_id.nil?
  end
end