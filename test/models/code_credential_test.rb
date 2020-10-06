require 'test_helper'

class CodeCredentialTest < ActiveSupport::TestCase
  test "belongs to client" do
    assert_equal clients(:sample_client), code_credentials(:sample_code_credential).client
  end

  test "has_many scopes through approved_scopes" do
    expected = [scopes(:foo), scopes(:bar)]
    actual = code_credentials(:sample_code_credential).scopes
    assert_equal [], expected - actual
  end
end
