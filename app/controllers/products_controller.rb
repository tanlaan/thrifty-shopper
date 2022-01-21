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
    @product.title = params[:title] || nil
    @product.upc = params[:upc] || nil
    @product.plu = Plu.find_or_create_by(code: params[:plu]) || nil
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

    # Identify if product already created redirect_to @product
    # or
    # redirect_to action: 'new', upc: '012345678901'}

    # Only contains digits
    if digits?(@query)
      # Too long to be UPC
      redirect_to root if @query.length > 12

      case @query.length

      # UPC length
      when 12
        @product = Upc.find_by(code: @query) ? Upc.find_by(code: @query).product : nil
        if @product
          redirect_to @product
        else
          redirect_to action: 'new', upc: @query
        end

      # PLU length
      when 4, 5
        @product = Plu.find_by(code: @query) ? Plu.find_by(code: @query).product : nil
        if @product
          redirect_to @product
        else
          redirect_to action: 'new', plu: @query
        end

      # is fragment
      else
        case @query.length
        when 6..11
          @code = Upc.find_by('code like ?', "%#{@query}%")
        when 1..3
          @code = Plu.find_by('code like ?', "%#{@query}%")
        end

        @product = @code.product

        if @product
          redirect_to @product
        else
          # failed to find and it's an irregular PLU/UPC
          redirect_to root
        end
      end

    # Title search
    else
      @product = Product.find_by('lower(title) like ?', "%#{@query.downcase}%")
      if @product
        redirect_to @product
      else
        redirect_to action: 'new', title: @query
      end
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

  # Check string for only digits
  def digits?(query)
    query.scan(/\D/).empty?
  end
end
