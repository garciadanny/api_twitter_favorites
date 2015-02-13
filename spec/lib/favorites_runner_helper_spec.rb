require 'rails_helper'

describe FavoritesRunnerHelper do

  let(:user) { create_user }

  let(:runner) { initialize_test_runner( user_id: user.id ) }

  let(:favorites) do
    [OpenStruct.new(id: 1), OpenStruct.new(id: 2)]
  end

  describe '#fetch' do

    let(:client) { runner.client }

    it 'should only fetch favorites with a count argument' do
      expect(client).to receive(:favorites).with( count: 200 )
      runner.fetch( {max_id: nil, since_id: nil} )
    end

    it 'should fetch favorites with count and max_id arguments' do
      expect(client).to receive(:favorites).with( count: 200, max_id: 2 )
      runner.fetch( {max_id: 2, since_id: nil} )
    end

    it 'should fetch favorites with all passed arguments' do
      expect(client).to receive(:favorites).with( count: 200, max_id: 2, since_id: 3 )
      runner.fetch( {max_id: 2, since_id: 3} )
    end

  end

  describe '#persist_favorites' do

    it 'persists all of the favorites' do
      expect{
        runner.persist_favorites( favorites )
      }.to change{Favorite.count}.by 2
    end

    context 'given a response returns no favorites' do
      it 'does not persist any data' do
        expect{
          runner.persist_favorites( [] )
        }.not_to change{Favorite.count}
      end
    end
  end

  describe '#optimized_max_id' do

    context 'given a #max_id' do
      before { runner.max_id = 5 }

      it 'returns 1 minus the #max_id' do
        expect(runner.optimized_max_id).to eq 4
      end
    end

    context 'given there is no #max_id' do

      it 'returns nil' do
        expect(runner.optimized_max_id).to eq nil
      end
    end
  end

  describe '#user' do

    it 'returns the user object' do
      expect(runner.user).to be_a_kind_of User
    end
  end

  describe '#new_favorites' do
    before do
      db_ids = [1, 3, 5, 7]
      allow(Favorite).to receive(:pluck).with(:twitter_id).and_return( db_ids )
    end

    it 'returns a list of favorites not already in the db' do
      new_favs = runner.new_favorites( favorites )
      expect(new_favs).to eq [favorites.last]
    end
  end
end