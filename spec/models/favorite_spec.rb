require 'rails_helper'

describe Favorite do

  before { Favorite.create user_id: 1, twitter_id: 1 }

  describe '#twitter_id unique validations' do

    context 'given a single user' do

      context 'when a new favorite is created with the same twitter_id' do
        it 'should be invalid' do
          invalid_favorite = Favorite.create user_id: 1, twitter_id: 1
          expect(invalid_favorite).not_to be_valid
        end
      end

      context 'when a new favorite is created with a unique twitter_id' do
        it 'should be valid' do
          valid_favorite = Favorite.create user_id: 1, twitter_id: 2
          expect(valid_favorite).to be_valid
        end
      end
    end

    context 'given multiple users' do

      context 'when a new favorite is created with the same twitter_id' do
        it 'should be valid' do
          valid_favorite = Favorite.create user_id: 2, twitter_id: 1
          expect(valid_favorite).to be_valid
        end
      end
    end
  end

  describe 'default scoping' do

    before { Favorite.create user_id: 1, twitter_id: 5 }

    it 'returns favorites in descending order by #twitter_id' do
      expect(Favorite.first.twitter_id).to eq 5
      expect(Favorite.last.twitter_id).to eq 1
    end
  end
end