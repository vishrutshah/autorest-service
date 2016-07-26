require 'test_helper'

class GenerateControllerTest < ActionDispatch::IntegrationTest
  test "should get client" do
    get generate_client_url
    assert_response :success
  end

end
