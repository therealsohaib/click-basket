class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :update, :destroy]

  def show
    cart= Rails.cache.fetch(["cart",@cart,@cart.updated_at],expires_in: 2.minutes) do
      {
        id: @cart.id,
        total_price: @cart.total_price,
        items: @cart.cart_items.includes(:product).map do |ci|
          {
            product: ci.product.name,
            quantity: ci.quantity,
            price: ci.product.price
          }
        end
      }
    end
    render json: cart
  end

  def create
    @cart = Cart.new(cart_params)
    if @cart.save
      render json: @cart, status: :created
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def update
    if @cart.update(cart_params)
      render json: @cart, status: :ok
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @cart.destroy
    head :no_content
  end
  private
  def set_cart
    @cart = Cart.find(params[:id])
  end
  def cart_params
    params.require(:cart).permit(:user_id, :total_price)
  end
end
