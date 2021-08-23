require "test_helper"

class RepuestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repuesto = repuestos(:one)
  end

  test "should get index" do
    get repuestos_url, as: :json
    assert_response :success
  end

  test "should create repuesto" do
    assert_difference('Repuesto.count') do
      post repuestos_url, params: { repuesto: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show repuesto" do
    get repuesto_url(@repuesto), as: :json
    assert_response :success
  end

  test "should update repuesto" do
    patch repuesto_url(@repuesto), params: { repuesto: {  } }, as: :json
    assert_response 200
  end

  test "should destroy repuesto" do
    assert_difference('Repuesto.count', -1) do
      delete repuesto_url(@repuesto), as: :json
    end

    assert_response 204
  end
end
