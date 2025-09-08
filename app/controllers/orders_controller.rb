class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :cancel]

  def index
    render json: Order.includes(:order_items)
  end

  def show
    render json: @order, include: :order_items
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
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

  # PATCH /orders/:id/cancel
  def cancel
    @order.update(status: "cancelled")
    render json: @order
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:user_id, :total_price, :status)
  end
end
