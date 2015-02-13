require 'rails_helper'

describe FavoriteRunner do

  let(:user) { create_user }
  let(:runner) { user.favorite_runner }

  describe '#update_trackers' do

    context 'given there are remaining tweets to request' do

      let(:favorites) { [ OpenStruct.new(id: 7) ] }

      it 'does not update #complete' do
        expect(runner).not_to receive(:update).with( complete: true )
        runner.update_trackers favorites
      end

      it 'updates #max_id with last tweet in the response' do
        expect(runner).to receive(:update).with( max_id: 7 )
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