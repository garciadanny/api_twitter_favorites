module OmniauthMockHelper
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = {
        'provider' => 'twitter',
        'uid' => '123545',
        'info' => {
            'nickname' => 'mockuser',
            'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        },
        'extra' => {
            'raw_info' => {
                'favourites_count' => 123
            }
        }
    }
  end
end