require "test_helper"

class CreaturesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get creatures_index_url
    assert_response :success
  end

  test "should get create" do
    get creatures_create_url
    assert_response :success
  end
end
