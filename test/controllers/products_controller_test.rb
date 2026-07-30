require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "lists products" do
    get products_path
    assert_response :success
    assert_select "table"
    assert_select "table tbody tr" do |rows|
      puts rows.count
      puts rows.first.text
    end
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { amount: @product.amount, description: @product.description, min: @product.min, name: @product.name, price: @product.price, sku: @product.sku, status: @product.status } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { amount: @product.amount, description: @product.description, min: @product.min, name: @product.name, price: @product.price, sku: @product.sku, status: @product.status } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
  test "creates a product" do
      get new_product_path
      assert_response :success

      sku = SecureRandom.uuid

      post "/products", params: {
        product: {
          name: "Laptop",
          description: "Gaming laptop",
          price: "1200",
          sku: sku,
          amount: "10",
          min: "1",
          status: "active"
        }
      }

      assert_response :redirect

      product = Product.find_by!(sku: sku)

      assert_equal "Laptop", product.name
      assert_equal "Gaming laptop", product.description
      assert_equal 1200, product.price
      assert_equal 10, product.amount
      assert_equal 1, product.min
      assert_equal "active", product.status
    end
    test "updates product price" do
      product = products(:one)

      get "/products/#{product.id}/edit"
      assert_response :success

      patch "/products/#{product.id}", params: {
        product: {
          price: "999"
        }
      }

      assert_response :redirect

      product.reload

      assert_equal 999, product.price
    end
    test "deletes a product" do
      product = products(:one)

      get "/products/#{product.id}"
      assert_response :success

      delete "/products/#{product.id}"

      assert_response :redirect

      assert_raises(ActiveRecord::RecordNotFound) do
        Product.find(product.id)
      end
    end
end
