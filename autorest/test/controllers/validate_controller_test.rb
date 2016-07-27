require 'test_helper'

class ValidateControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get validate_index_url
    assert_response :success
  end

end
