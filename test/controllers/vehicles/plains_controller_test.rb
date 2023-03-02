require "test_helper"

class Vehicles::PlainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vehicles_plains_index_url
    assert_response :success
  end
end
