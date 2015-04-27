require 'rails_helper'

describe TwitterFavoritesJob do
  include ActiveJob::TestHelper

  let(:user) { create_user }
  let(:favorite_runner_double) do
    instance_double(FavoriteRunner, start: true, rate_limit_reset_time: Time.now.tomorrow)
  end

  before do
    # Mock out the FavoriteRunner
    allow_any_instance_of(TwitterFavoritesJob).to receive(:favorite_runner).and_return(favorite_runner_double)
    # Simulate a completed FavoriteRunner after the first run.
    allow(favorite_runner_double).to receive(:complete?).and_return(true)
  end

  after do
    clear_performed_jobs
  end

  describe '#perform' do
      it 'starts the favorite_runner' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 1
        end
      end
  end

  describe '#enqueue_next_job' do

    context 'given the favorite_runner is not complete after the first job' do

      before do
        # Simulate a completed FavoriteRunner after the second run.
        allow(favorite_runner_double).to receive(:complete?).and_return(false, true)
      end

      it 'starts the favorite_runner twice' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 2
        end
      end
    end

    context 'given the favorite_runner is complete after the first job' do

      it 'only start the FavoriteRunner once' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( user )
          expect(performed_jobs.size).to eq 1
        end
      end
    end
  end
end