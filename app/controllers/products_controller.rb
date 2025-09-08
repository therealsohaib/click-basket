class ProductsController < ApplicationController
  before_action :set_product, only: [:show,  :update, :destroy]
  def index
  @products = Product.includes(:category).in_stock
  render json: @products, include: :category
  end
  def show
    render json: @product, include: :category
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @product.destroy
    head :no_content
  end
  private
  def set_product
    @product = Product.find(params[:id])
  end
  def product_params
    params.require(:product).permit(:name, :price, :sku, :description, :stock_quantity, :category_id)
  end
end
