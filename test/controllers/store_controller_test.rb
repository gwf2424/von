require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "store.coffee add submit for all pruduct's img" do
  	get :index
  	assert_select '.entry > img', 2
  	assert_select '.entry input[type=submit]', 2
  end
end
