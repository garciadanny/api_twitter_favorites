class RestClient
  attr_reader :service, :user

  def self.new service, user
    instance = super
    instance.client
  end

  private

  def initialize service, user
    @service = service
    @user = user
    extend decorator
  end

  def decorator
    "#{service.to_s.capitalize}Client".constantize
  end
end