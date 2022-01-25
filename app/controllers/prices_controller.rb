class PricesController < ApplicationController
  before_action :set_price, only: %i[ show edit update destroy ]

  # GET /prices or /prices.json
  def index
    @prices = Price.all
  end

  # GET /prices/1 or /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @price = Price.new
    @price.product = Product.find(params[:product_id])
    # @product = Product.find(params[:product_id])
  end

  # GET /prices/1/edit
  def edit
    @product = @price.product
  end

  # POST /prices or /prices.json
  def create
    @price = Price.new(price_params)

    respond_to do |format|
      if @price.save
        format.html { redirect_to product_url(@price.product), notice: "Price was successfully created." }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prices/1 or /prices/1.json
  def update
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to product_url(@price.product), notice: "Price was successfully updated." }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prices/1 or /prices/1.json
  def destroy
    @product = @price.product
    @price.destroy

    respond_to do |format|
      format.html { redirect_to product_url(@product), notice: "Price was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = Price.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def price_params
      params.require(:price).permit(:price, :product_id, :store_id, store_attributes: [:name])
    end
end
