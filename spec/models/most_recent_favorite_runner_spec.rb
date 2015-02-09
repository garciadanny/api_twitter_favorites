require 'rails_helper'

  describe MostRecentFavoriteRunner do

    let(:user) { create_user }
    let(:runner) { user.most_recent_favorite_runner }

    describe '#update_trackers' do

      context 'given there are remaining tweets to request' do

        let(:favorites) { [ OpenStruct.new(id: 7) ] }

        it 'updates the #max_id to the last tweet in the response' do
          expect(runner).to receive(:update).with( max_id: 7 )
          runner.update_trackers favorites, 1
        end
      end

      context 'given there are no remaining tweets to request' do

        let(:favorites) { [] }

        it 'wipes out the #max_id' do
          expect(runner).to receive(:update).with( max_id: nil )
          runner.update_trackers favorites, 0
        end

        context 'given we have only issued 1 request' do

          it 'preserves the #since_id by not updating it' do
            # counter starts at 0
            expect(runner).not_to receive(:update).with( hash_including(:since_id) )
            runner.update_trackers favorites, 0
          end
        end

        context 'given we have issued more than 1 request' do

          before do
            # stub reaching into the db to get the first Favorite
            allow_message_expectations_on_nil
            allow(Favorite.first).to receive(:twitter_id).and_return :some_id
            # Here we're saying we don't care about anything else that gets
            # updated. We just care that the #since_id is updated.
            allow(runner).to receive(:update).exactly(2).times
          end

          it 'updates the #since_id with the most recent favorite in the db' do
            expect(runner).to receive(:update).with( since_id: :some_id )
            runner.update_trackers favorites, 2
          end
        end
      end
    end
  end