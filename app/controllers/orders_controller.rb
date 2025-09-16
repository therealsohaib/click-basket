class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :cancel]

  def index
    render json: Order.includes(:order_items)
  end

  def show
    render json: @order, include: :order_items
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
