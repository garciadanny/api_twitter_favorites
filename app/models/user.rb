class User < ActiveRecord::Base

  def self.create_user auth
    create! do |user|
      user.twitter_id = auth['uid']
      user.twitter_handle = auth['info']['nickname']
      user.access_token = auth['credentials']['token']
      user.access_token_secret = auth['credentials']['secret']
      user.initial_favorites_count = auth['extra']['raw_info']['favourites_count']
    end
  end
end