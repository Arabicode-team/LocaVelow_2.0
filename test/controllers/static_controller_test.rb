require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get terms_and_conditions" do
    get static_terms_and_conditions_url
    assert_response :success
  end
end
