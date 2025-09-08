class OrderItemsController < ApplicationController
  before_action :set_order
  before_action :set_order_item, only: [:update, :destroy]

  def create

    product = Product.find(order_item_params[:product_id])
    @order_item=@order.order_items.build(
    product: product,
    quantity: order_item_params[:quantity],
    price: product.price
    )
    if @order_item.save
      render json: @order_item, status: :created
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order_item.update(quantity: order_item_params[:quantity])
      render json: @order_item
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order_item.destroy
    head :no_content
  end

  private
  def set_order
    @order = Order.find(params[:order_id])
  end
  def set_order_item
    @order_item = @order.order_items.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:product_id, :quantity)
  end
end
