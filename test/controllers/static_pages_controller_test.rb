require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  # def setup
  #  @base_title = "Ruby on Rails"
  # end


  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Von's website 1@11. 1*6"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Von's website 1@11. 1*6"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Von's website 1@11. 1*6"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | Von's website 1@11. 1*6"
  end

end
