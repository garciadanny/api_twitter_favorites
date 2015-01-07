class SessionsController < ApplicationController

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by(twitter_id: auth['uid']) || User.create_user(auth)
    render nothing: true # Will need to Redirect user to Ember app
    # TODO
    # Set up background workers to start getting favorites
    # Create Session
  end
end