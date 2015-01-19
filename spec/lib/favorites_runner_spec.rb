require 'rails_helper'

describe FavoritesRunner do

  let(:user) { create_user }

  let(:runner) { FavoritesRunner.new( user ) }

  let(:favorites) do
    [Twitter::Tweet.new(id: 1), Twitter::Tweet.new(id: 2)]
  end

  describe '#fetch' do
    # New user context and Existing user context:
      # Here, we're stubbing out client#favorites because we don't want the twitter client
      # to make actual requests to the twitter API. We trust that this external client works.
      # The only thing we're concerned about is that we provide the client with the correct
      # arguments before making the request to the API.

    let(:client) { runner.send :client }
    context 'given a new user' do
      it 'should only fetch favorites with a count argument' do
        expect(client).to receive(:favorites).with({count: 200})
        runner.send :fetch
      end
    end

    context 'given an existing user' do
      it 'should fetch favorites with both count and max_id arguments' do
        user.last_fetched_favorite.update favorite_id: 123

        expect(client).to receive(:favorites).with({count: 200, max_id: 123})
        runner.send :fetch
      end
    end
  end

  describe '#persist_favorites' do

    context 'given a new user' do
      it 'persists all of the favorites' do
        expect(user.favorites).to receive(:create_favorites).twice
        runner.send( :persist_favorites, favorites )
      end
    end

    context 'given an existing user' do
      # The first favorite is the max_id favorite we already have.
      it 'perists all but the first favorite' do
        user.last_fetched_favorite.update favorite_id: 123

        expect(user.favorites).to receive(:create_favorites).once
        runner.send( :persist_favorites, favorites )
      end
    end
  end

  describe '#update_last_fetched_favorite' do

    it 'updates the id of the last fetched favorite' do
      expect{
        runner.send(:update_last_fetched_favorite, favorites)
      }.to change{user.last_fetched_favorite.favorite_id}.from(nil).to(2)
    end

    context 'when there are no more favorites to request' do
      it 'sets last_fetched_favorite#last_favorite to true' do
        expect{
          runner.send(:update_last_fetched_favorite, favorites)
        }.to change{user.last_fetched_favorite.last_favorite}.from(false).to(true)
      end
    end

    context 'when there are remaining favorites to request' do
      it 'does not set last_fetched_favorite#last_favorite to true' do
        allow(favorites).to receive(:count).and_return 200

        expect{
          runner.send(:update_last_fetched_favorite, favorites)
        }.not_to change{ user.last_fetched_favorite.last_favorite }
      end
    end
  end

  describe '#start' do

    before do
      allow(runner).to receive(:fetch).and_return(favorites)
      # stub db calls
      allow(user.favorites).to receive(:create_favorites).with(any_args).at_least(15).times
    end

    it 'calls #fetch 15 times' do
      expect(runner).to receive(:fetch).at_most(15).times
      runner.start
    end

    it 'calls #persist_favorites 15 times' do
      expect(runner).to receive(:persist_favorites).with(favorites).at_most(15).times
      runner.start
    end

    it 'calls #update_last_fetched_favorite 15 times' do
      expect(runner).to receive(:update_last_fetched_favorite).with(favorites).at_most(15).times
      runner.start
    end
  end
end