require 'test_helper'

class ApprovedScopeTest < ActiveSupport::TestCase
  test "belongs to code_credentials" do
    assert_equal code_credentials(:sample_code_credential), approved_scopes(:foo).code_credential
  end

  test "belongs to scopes" do
    assert_equal scopes(:foo), approved_scopes(:foo).scope
  end
end
