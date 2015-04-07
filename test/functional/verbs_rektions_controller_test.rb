require 'test_helper'

class VerbsRektionsControllerTest < ActionController::TestCase
  setup do
    @verbs_rektion = verbs_rektions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:verbs_rektions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create verbs_rektion" do
    assert_difference('VerbsRektion.count') do
      post :create, verbs_rektion: { case: @verbs_rektion.case, preposition: @verbs_rektion.preposition, translation: @verbs_rektion.translation, verb: @verbs_rektion.verb }
    end

    assert_redirected_to verbs_rektion_path(assigns(:verbs_rektion))
  end

  test "should show verbs_rektion" do
    get :show, id: @verbs_rektion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @verbs_rektion
    assert_response :success
  end

  test "should update verbs_rektion" do
    put :update, id: @verbs_rektion, verbs_rektion: { case: @verbs_rektion.case, preposition: @verbs_rektion.preposition, translation: @verbs_rektion.translation, verb: @verbs_rektion.verb }
    assert_redirected_to verbs_rektion_path(assigns(:verbs_rektion))
  end

  test "should destroy verbs_rektion" do
    assert_difference('VerbsRektion.count', -1) do
      delete :destroy, id: @verbs_rektion
    end

    assert_redirected_to verbs_rektions_path
  end
end
