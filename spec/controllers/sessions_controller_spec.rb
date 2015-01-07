require 'rails_helper'

describe SessionsController do

  describe '#create' do

    before do
      mock_auth_hash
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end

    context 'given a new user' do
      it 'should create a new user' do
        expect {
          post :create, provider: :twitter
        }.to change{User.count}.by 1
      end
    end

    context 'given an existing user' do
      before do
        User.create_user OmniAuth.config.mock_auth[:twitter]
      end

      it 'should find (not create) a user' do
        expect {
          post :create, provider: :twitter
        }.not_to change{User.count}
      end
    end
  end
end