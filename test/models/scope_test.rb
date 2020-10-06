require "test_helper"

class ScopeTest < ActiveSupport::TestCase
  test "belongs to client" do
    assert_equal clients(:sample_client), scopes(:foo).client
  end

  test "has_many approved_scopes" do
    expected = [approved_scopes(:foo)]
    actual = scopes(:foo).approved_scopes
    assert_equal [], expected - actual
  end
end
