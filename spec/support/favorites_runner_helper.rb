module FavoritesRunnerHelper
  class TestRunner
    include FavoritesRunner
    attr_accessor :max_id, :user_id

    def initialize args
      @max_id = args[:max_id]
      @user_id = args[:user_id]
    end
  end

  def initialize_test_runner args
    TestRunner.new args
  end
end