require "test_helper"

class StonePartsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stone_parts_index_url
    assert_response :success
  end

  test "should get show" do
    get stone_parts_show_url
    assert_response :success
  end

  test "should get new" do
    get stone_parts_new_url
    assert_response :success
  end

  test "should get edit" do
    get stone_parts_edit_url
    assert_response :success
  end

  test "should get create" do
    get stone_parts_create_url
    assert_response :success
  end

  test "should get update" do
    get stone_parts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get stone_parts_destroy_url
    assert_response :success
  end
end
