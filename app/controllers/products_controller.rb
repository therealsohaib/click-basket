class ProductsController < ApplicationController
  before_action :set_product, only: [:show,  :update, :destroy]
  def index
    logger.debug ">>> Incoming params: #{params.inspect}"

    @products = Product.includes(:category).in_stock

    products=@products.map do |product|
      Rails.cache.fetch(["product", product, product.updated_at]) do
        {
          id: product.id,
          name: product.name,
          price: product.price,
          sku: product.sku,
          description: product.description,
          stock_quantity: product.stock_quantity,
          category: {
            id: product.category.id,
            name: product.category.name
          }
        }
      end
    end

  render json: products
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
