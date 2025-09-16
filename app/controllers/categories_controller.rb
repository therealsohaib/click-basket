class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]
  def index
    categories=Rails.cache.fetch("categories_index", expires_in: 5.minute) do
      Category.all.as_json(only: [:id, :name])
    end
    render json: categories
  end
  def show
    render json: @category, include: :products
  end
  def create
  @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end
  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @category.destroy
    head :no_content
  end
  private
  def set_category
    @category = Category.find(params[:id])
  end
  def category_params
    params.require(:category).permit(:name)
  end
end
