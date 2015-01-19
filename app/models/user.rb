class User < ActiveRecord::Base
  has_one :last_fetched_favorite, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def self.create_user auth
    create! do |user|
      user.twitter_id = auth['uid']
      user.twitter_handle = auth['info']['nickname']
      user.initial_favorites_count = auth['extra']['raw_info']['favourites_count']
      user.access_token = auth['credentials']['token']
      user.access_token_secret = auth['credentials']['secret']
      user.build_last_fetched_favorite
    end
  end

  def new_user?
    last_fetched_favorite.favorite_id.nil?
  end
end