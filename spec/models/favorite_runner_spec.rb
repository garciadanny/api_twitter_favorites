require 'rails_helper'

describe FavoriteRunner do

  let(:user) { create_user }
  let(:runner) { user.favorite_runner }

  describe '#update_trackers' do

    context 'given there are remaining tweets to request' do

      let(:favorites) { [ OpenStruct.new(id: 7) ] }

      it 'updates #complete to false and sets the #max_id' do
        expect(runner).to receive(:update).twice
        runner.update_trackers favorites
      end
    end

    context 'given there are no remaining tweets to request' do

      let(:favorites) { [] }

      it 'updates #complete to true and unsets #max_id' do
        expect(runner).to receive(:update).twice
        runner.update_trackers favorites
      end
    end
  end
end