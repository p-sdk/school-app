class CategoriesController < ApplicationController
  expose(:categories)
  expose(:category, attributes: :category_params)

  before_action :require_sign_in, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def create
    if category.save
      flash[:success] = 'Kategoria została utworzona'
      redirect_to category
    else
      render :new
    end
  end

  def update
    if category.save
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
