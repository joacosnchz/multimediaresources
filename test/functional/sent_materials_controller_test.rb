require 'test_helper'

class SentMaterialsControllerTest < ActionController::TestCase
  setup do
    @sent_material = sent_materials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sent_materials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sent_material" do
    assert_difference('SentMaterial.count') do
      post :create, sent_material: {  }
    end

    assert_redirected_to sent_material_path(assigns(:sent_material))
  end

  test "should show sent_material" do
    get :show, id: @sent_material
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sent_material
    assert_response :success
  end

  test "should update sent_material" do
    put :update, id: @sent_material, sent_material: {  }
    assert_redirected_to sent_material_path(assigns(:sent_material))
  end

  test "should destroy sent_material" do
    assert_difference('SentMaterial.count', -1) do
      delete :destroy, id: @sent_material
    end

    assert_redirected_to sent_materials_path
  end
end
