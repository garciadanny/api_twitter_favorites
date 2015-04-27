require 'rails_helper'

describe TwitterClient do
  context 'given a user' do
    it 'returns an instance of a twitter rest client' do
      user = User.create
      client = TwitterClient.new( user )
      expect(client).to be_a TwitterClient
    end
  end
end