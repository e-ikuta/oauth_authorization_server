require "test_helper"

class RedirectUriTest < ActiveSupport::TestCase
  test "belongs to client" do
    assert_equal clients(:sample_client), redirect_uris(:sample_uri_1).client
  end
end
