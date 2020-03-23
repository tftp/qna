module OmniauthMacros
  def mock_auth_hash_github
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '12345',
      'info' => {
        'email' => 'test@github.com'
      }
    }
  end

  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'facebook',
      'uid' => '12345',
      'info' => {
        'email' => 'test@facebook.com'
      }
    }
  end

  def mock_auth_hash_github_invalid
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
  end

  def mock_auth_hash_facebook_invalid
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end
