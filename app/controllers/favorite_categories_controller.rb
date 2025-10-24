class FavoriteCategoriesController < ApplicationController
  include ReactProps
  before_action :require_login

  def edit
    @user = current_user
    build_favorite_categories_props
  end

  def update
    @user = current_user
    if params[:user] && params[:user][:category_ids].present?
      selected_ids = params[:user][:category_ids].reject(&:blank?)
      @user.category_ids = selected_ids
    else
      @user.categories.clear
    end
    redirect_to root_path, notice: "Welcome!"
  end

  private

  def build_favorite_categories_props
    categories = Category.all.order(:name)
    @favorite_categories_props = {
      form: {
        action: favorite_categories_path,
        method: "patch",
        selectedIds: @user.category_ids,
        categories: categories.map { |category| { id: category.id, name: category.name } }
      },
      skipPath: root_path,
      csrfToken: react_csrf_token
    }
  end
end
