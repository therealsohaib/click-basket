class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :cancel]

  def index
    render json: Order.includes(:order_items)
  end

  def show
    order = Rails.cache.fetch(["order", @order, @order.updated_at]) do
      {
        id: @order.id,
        status: @order.status,
        total_price: @order.total_price,
        items: @order.order_items.includes(:product).map do |item|
          Rails.cache.fetch(["order_item", item, item.updated_at]) do
            {
              id: item.id,
              quantity: item.quantity,
              price: item.price,
              product: Rails.cache.fetch(["product", item.product, item.product.updated_at]) do
                {
                  id: item.product.id,
                  name: item.product.name,
                  price: item.product.price
                }
              end
            }
          end
        end
      }
    end

    render json: order
  end
  def create

    logger.debug ">>> Incoming params: #{params.inspect}"

    cart=Cart.find_by(user_id: order_params[:user_id])

    if cart.nil? || cart.cart_items.empty?
      return render json: {error: "Couldn't find cart with user_id #{order_params[:user_id]}"}
    end
    order = Order.create!(
    user_id: cart.user,
    total_price: cart.cart_items.sum {|cart_item| cart_item.price * cart_item.quantity},
    status: "pending"
    )

    cart.cart_items.each do |cart_item|
      OrderItem.create!(
        order: order,
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.price,
      )
    end

    cart.cart_items.destroy_all

    render json: { message: I18n.t("orders.created") }, include: :order_items, status: :created

  end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    head :no_content
  end

  def cancel
    @order.update(status: "cancelled")
    render json: {message: I18n.t("orders.cancelled", id: @order.id)}
    destroy
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:user_id)
  end
end
