require 'test_helper'

class MediaTypesControllerTest < ActionController::TestCase
  setup do
    @media_type = media_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_type" do
    assert_difference('MediaType.count') do
      post :create, media_type: { description: @media_type.description, name: @media_type.name }
    end

    assert_redirected_to media_type_path(assigns(:media_type))
  end

  test "should show media_type" do
    get :show, id: @media_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_type
    assert_response :success
  end

  test "should update media_type" do
    put :update, id: @media_type, media_type: { description: @media_type.description, name: @media_type.name }
    assert_redirected_to media_type_path(assigns(:media_type))
  end

  test "should destroy media_type" do
    assert_difference('MediaType.count', -1) do
      delete :destroy, id: @media_type
    end

    assert_redirected_to media_types_path
  end
end
