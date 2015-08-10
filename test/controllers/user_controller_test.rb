require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get registration" do
    get :registration
    assert_response :success
  end

  test "should get signin" do
    get :signin
    assert_response :success
  end

  test "should get signout" do
    get :signout
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get follow" do
    get :follow
    assert_response :success
  end

end
