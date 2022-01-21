class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    # This would be to lower the amount of queries being sent on index load, but I'm not sure it's needed?
    @products = Product.all.includes(:brand, :category, :weight_unit, :volume_unit, :upc, :plu)
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
    @product.title = params[:title] || nil
    @product.upc = params[:upc] || nil
    @product.plu = params[:plu] || nil
  end

  # GET /products/1/edit
  def edit
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
    redirect_to products_path if @query.nil? || @query == ''

    @products, @upc, @plu, @title = Product.search(@query)

    if @products.length > 1
      # Pass list of object ids to list view page?
    elsif @products.length == 1
      redirect_to @products[0]
    elsif @upc.nil? && @plu.nil? && @title.nil?
      redirect_to root_path
    else
      redirect_to action: 'new', upc: @upc, plu: @plu, title: @title
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:title, :alias, :description, :weight, :weight_unit_id, :volume, :volume_unit_id, :brand_id, :category_id, :upc_id, :plu_id)
  end
end
