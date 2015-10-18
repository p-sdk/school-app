class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :require_sign_in, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Kategoria została utworzona'
      redirect_to @category
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Kategoria została zaktualizowana'
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    flash[:success] = 'Kategoria została usunięta'
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
