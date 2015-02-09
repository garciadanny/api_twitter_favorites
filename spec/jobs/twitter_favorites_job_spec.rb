require 'rails_helper'

describe TwitterFavoritesJob do
  include ActiveJob::TestHelper

  let(:user) { create_user }

  before do
    # Stub calls to #start to avoid making API requests and calls to the db.
    allow_any_instance_of(LeastRecentFavoriteRunner).to receive(:start)
    allow_any_instance_of(MostRecentFavoriteRunner).to receive(:start)
  end

  after do
    clear_performed_jobs
  end

  describe '#perform' do

    context 'given the least_recent_favorite_runner is not complete' do

      before do
        # Stub out calls to #complete? to avoid "stack level too deep" errors.
        allow(user.least_recent_favorite_runner).to receive(:complete?).and_return(false, true)
      end

      it 'starts the least_recent_favorite_runner' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 1
        end
      end
    end

    context 'given the least_recent_favorite_runner is complete' do

      before do
        # Stub out calls to #complete? to avoid "stack level too deep" errors.
        allow(user.least_recent_favorite_runner).to receive(:complete?).and_return(true)
      end

      it "starts the most_recent_favorite_runner" do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 1
        end
      end
    end
  end

  describe '#enqueue_next_job' do

    context 'given the least_recent_favorite_runner is not complete' do

      before do
        # Stub out calls to #complete? to avoid "stack level too deep" errors.
        allow(user.least_recent_favorite_runner).to receive(:complete?).and_return(false, false, true)
      end

      it 'starts the least_recent_favorite_runner twice' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 2
        end
      end
    end

    context 'given the least_recent_favorite_runner is complete' do

      before do
        # Stub out calls to #complete? to avoid "stack level too deep" errors.
        allow(user.least_recent_favorite_runner).to receive(:complete?).and_return(true)
      end

      it 'only start the MostRecentFavoriteRunner once' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 1
        end
      end
    end
  end
end