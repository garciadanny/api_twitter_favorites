class User < ActiveRecord::Base

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

  def fetch_favorites options={}
    starting_point = options[:starting_point]
    if starting_point
      client.favorites( count: 200, max_id: starting_point )
    else
      client.favorites( count: 200 )
    end
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |c|
      c.consumer_key = ENV['TWITTER_FAVORITES_KEY']
      c.consumer_secret = ENV['TWITTER_FAVORITES_SECRET']
      c.access_token = access_token # need to encrypt in db
      c.access_token_secret = access_token_secret # need to encrypt in db
    end
  end
end