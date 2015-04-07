require 'test_helper'

class ThemasControllerTest < ActionController::TestCase
  setup do
    @thema = themas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:themas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create thema" do
    assert_difference('Thema.count') do
      post :create, thema: { name: @thema.name, part: @thema.part }
    end

    assert_redirected_to thema_path(assigns(:thema))
  end

  test "should show thema" do
    get :show, id: @thema
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @thema
    assert_response :success
  end

  test "should update thema" do
    put :update, id: @thema, thema: { name: @thema.name, part: @thema.part }
    assert_redirected_to thema_path(assigns(:thema))
  end

  test "should destroy thema" do
    assert_difference('Thema.count', -1) do
      delete :destroy, id: @thema
    end

    assert_redirected_to themas_path
  end
end
