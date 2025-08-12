class FavoriteCategoriesController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
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
end
