require 'rails_helper'

describe TwitterFavoritesJob do
  include ActiveJob::TestHelper

  let(:user) { User.create }

  let(:favorites) do
    [Twitter::Tweet.new(id: 1), Twitter::Tweet.new(id: 2)]
  end

  before do
    allow_any_instance_of(FavoritesRunner).to receive(:fetch).and_return favorites
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform' do

    it "enqueue's a job to be performed when the queue is free" do
        TwitterFavoritesJob.perform_later( 'FavoritesRunner', user)
        expect(enqueued_jobs.size).to eq 1
    end
  end

  describe '#enqueue_next_job' do

    context 'when there are remaining favorited tweets' do

      before do
        # The first/second time #enqueue_next_job is called, #last_favorite? will return false
        # indicating there are remainging tweets and to enqueue another job.
        # The third time #enqueue_next_job is called, it'll return true
        # indicating there are no more remainging tweets and another job does not need to be queued.
        # This will avoid a "stack level too deep" error in our test
        allow(user.last_fetched_favorite).to receive(:last_favorite?).and_return(false, false, true)
      end

      it "performs another job for a total of 2 jobs" do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( 'FavoritesRunner', user)
          expect(performed_jobs.size).to eq 2
        end
      end
    end

    context 'when there are no more remainging tweets' do
      it 'performs a total of one job' do
        perform_enqueued_jobs do
          TwitterFavoritesJob.perform_later( 'FavoritesRunner', user)
          expect(performed_jobs.size).to eq 1
        end
      end
    end
  end
end