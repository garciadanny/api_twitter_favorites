require 'rails_helper'

describe RestClient do
  context 'given a twitter service type' do
    it 'returns an instance of a twitter rest client' do
      user = User.create
      client = RestClient.new :twitter, user
      expect(client).to be_a Twitter::REST::Client
    end
  end
end