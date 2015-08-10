require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test "should get signin" do
    get :signin
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get signout" do
    get :signout
    assert_response :success
  end

  test "should get registration" do
    get :registration
    assert_response :success
  end

end
