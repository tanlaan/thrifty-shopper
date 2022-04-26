class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    # This would be to lower the amount of queries being sent on index load, but I'm not sure it's needed?
    @products = Product.all.includes(:brand, :categories, :unit, :upc)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new

    # Fix these, otherwise I have to find_or_create_by
    # If a use cancels a product, do I want the PLU or UPC floating around?
    # I suppose that's not bad, it's just meant as a potential size savings and
    # to make sure they match up correctly with a product
    #
    # Do I want UPCs or PLUs that don't have a product association?
    @name = params[:name] || nil
    @upc = params[:upc] || nil
  end

  # GET /products/1/edit
  def edit
    @name = @product.name
    @upc = @product.upc ? @product.upc.code : nil
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /search?query=
  def search
    @query = params[:query]

    # Blank search or accidental url input without query
    redirect_to products_path and return if @query.nil? || @query == ''

    @products, @upc, @name = Product.search(@query)

    if @products.empty?
      redirect_to root_path and return if @upc.nil? && @name.nil?

      redirect_to action: 'new', upc: @upc, name: @name
    elsif @products.length == 1
      redirect_to @products[0]
    else
      # Pass list of object ids to list view page?
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
    @categories = !@product.categories.empty? ? @product.categories.map(&:name).join(', ') : ''
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :magnitude,
                                    :unit_id, :brand_id, :upc_id,
                                    brand_attributes: [:name],
                                    category_attributes: [:list],
                                    upc_attributes: [:code])
  end
end
