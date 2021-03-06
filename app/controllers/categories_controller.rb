class CategoriesController < ApplicationController
  expose_decorated(:categories) { policy_scope Category.all }
  expose(:category)

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :authorize_category

  def create
    if category.save
      flash[:success] = t '.success'
      redirect_to category
    else
      render :new
    end
  end

  def update
    if category.update(category_params)
      flash[:success] = t '.success'
      redirect_to category
    else
      render :edit
    end
  end

  def destroy
    category.destroy
    flash[:success] = t '.success'
    redirect_to categories_path
  end

  private

  def category_params
    permitted_attributes(Category)
  end

  def authorize_category
    authorize category
  end
end
