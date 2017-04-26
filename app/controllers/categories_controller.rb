class CategoriesController < ApplicationController
  expose_decorated(:categories) { Category.all }
  expose(:category)

  before_action :authenticate_user!, except: %i(index show)
  before_action :require_admin, except: %i(index show)

  def create
    if category.save
      flash[:success] = 'Kategoria została utworzona'
      redirect_to category
    else
      render :new
    end
  end

  def update
    if category.update(category_params)
      flash[:success] = 'Kategoria została zaktualizowana'
      redirect_to category
    else
      render :edit
    end
  end

  def destroy
    category.destroy
    flash[:success] = 'Kategoria została usunięta'
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
