class ProfilesController < ApplicationController
  include ReactProps
  before_action :require_login

  def edit
    @user = current_user
    build_profile_props
  end

  def update
    @user = current_user
    attrs = profile_params.except(:category_ids)
    if attrs[:password].blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation)
    end
    if @user.update(attrs)
      if params[:user] && params[:user][:category_ids].present?
        selected_ids = params[:user][:category_ids].reject(&:blank?)
        @user.category_ids = selected_ids
      else
        @user.categories.clear
      end
      redirect_to profile_path, notice: "Profile updated"
    else
      build_profile_props
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, category_ids: [])
  end

  def build_profile_props
    categories = Category.all.order(:name)
    @profile_props = {
      form: {
        action: profile_path,
        method: "patch",
        name: @user.name,
        email: @user.email,
        errors: @user.errors.full_messages,
        fieldErrors: @user.errors.to_hash(true)
      },
      categoriesForm: {
        action: profile_path,
        method: "patch",
        selectedIds: @user.category_ids,
        categories: categories.map { |category| { id: category.id, name: category.name } }
      },
      csrfToken: react_csrf_token
    }
  end
end
