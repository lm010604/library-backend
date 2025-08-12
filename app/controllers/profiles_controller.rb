class ProfilesController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
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
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, category_ids: [])
  end
end
