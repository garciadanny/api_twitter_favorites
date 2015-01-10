require 'rails_helper'

describe FavoritesFetcher do

  before do
    User.create
  end

  describe '#fetch' do
    # New user context and Existing user context:
      # Here, we're stubbing out client#favorites because we don't want the twitter client
      # to make actual requests to the twitter API. We trust that this external client works.
      # The only thing we're concerned about is that we provide the client with the correct
      # arguments before making the request to the API.
    context 'given a new user' do
      it 'should only fetch favorites with a count argument' do
        fetcher = FavoritesFetcher.new( User.last )
        client = fetcher.send :client

        expect(client).to receive(:favorites).with({count: 200})
        fetcher.send :fetch
      end
    end

    context 'given an existing user' do
      it 'should fetch favorites with both count and max_id arguments' do
        user = User.last
        user.last_fetched_favorite.update favorite_id: 123
        fetcher = FavoritesFetcher.new( user )
        client = fetcher.send :client

        expect(client).to receive(:favorites).with({count: 200, max_id: 123})
        fetcher.send :fetch
      end
    end
  end

  describe '#persist_favorites' do

  end

  describe '#update_last_fetched_favorite' do

  end

  describe '#start' do

  end
end