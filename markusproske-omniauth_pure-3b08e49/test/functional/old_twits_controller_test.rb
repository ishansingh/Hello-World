require 'test_helper'

class OldTwitsControllerTest < ActionController::TestCase
  setup do
    @old_twit = old_twits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:old_twits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create old_twit" do
    assert_difference('OldTwit.count') do
      post :create, :old_twit => @old_twit.attributes
    end

    assert_redirected_to old_twit_path(assigns(:old_twit))
  end

  test "should show old_twit" do
    get :show, :id => @old_twit.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @old_twit.to_param
    assert_response :success
  end

  test "should update old_twit" do
    put :update, :id => @old_twit.to_param, :old_twit => @old_twit.attributes
    assert_redirected_to old_twit_path(assigns(:old_twit))
  end

  test "should destroy old_twit" do
    assert_difference('OldTwit.count', -1) do
      delete :destroy, :id => @old_twit.to_param
    end

    assert_redirected_to old_twits_path
  end
end
