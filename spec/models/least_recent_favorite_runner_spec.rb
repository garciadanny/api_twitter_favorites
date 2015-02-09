require 'rails_helper'

describe LeastRecentFavoriteRunner do

  let(:user) { create_user }
  let(:runner) { user.least_recent_favorite_runner }

  describe '#update_trackers' do

    context 'given there are remaining tweets to request' do

      let(:favorites) { [ OpenStruct.new(id: 7) ] }

      it 'does not update most_recent_favorite_runner#since_id' do
        most_recent_runner = user.most_recent_favorite_runner
        expect(most_recent_runner).not_to receive(:update).with(any_args)

        runner.update_trackers favorites
      end

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

      before do
        # stub reaching into the db to get the first Favorite
        allow_message_expectations_on_nil
        allow(Favorite.first).to receive(:twitter_id).and_return :some_id
      end

      it 'updates most_recent_favorite_runner#since_id' do
        # How can we refactor this test to not make db calls
        expect_any_instance_of(MostRecentFavoriteRunner)
          .to receive(:update).with( since_id: :some_id)

        runner.update_trackers favorites
      end

      it 'updates #complete to true' do
        expect(runner).to receive(:update).with( complete: true )
        runner.update_trackers favorites
      end

      it 'does not update #max_id' do
        expect(runner).not_to receive(:update).with( hash_including(:max_id) )
        runner.update_trackers favorites
      end
    end
  end
end