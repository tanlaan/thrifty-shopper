require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    fill_in "Alias", with: @product.alias
    fill_in "Brand", with: @product.brand_id
    fill_in "Category", with: @product.category_id
    fill_in "Description", with: @product.description
    fill_in "Plu", with: @product.plu_id
    fill_in "Title", with: @product.title
    fill_in "Upc", with: @product.upc_id
    fill_in "Volume", with: @product.volume
    fill_in "Volume unit", with: @product.volume_unit_id
    fill_in "Weight", with: @product.weight
    fill_in "Weight unit", with: @product.weight_unit_id
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    fill_in "Alias", with: @product.alias
    fill_in "Brand", with: @product.brand_id
    fill_in "Category", with: @product.category_id
    fill_in "Description", with: @product.description
    fill_in "Plu", with: @product.plu_id
    fill_in "Title", with: @product.title
    fill_in "Upc", with: @product.upc_id
    fill_in "Volume", with: @product.volume
    fill_in "Volume unit", with: @product.volume_unit_id
    fill_in "Weight", with: @product.weight
    fill_in "Weight unit", with: @product.weight_unit_id
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
