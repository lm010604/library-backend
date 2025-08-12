class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.except(:category_ids))
    if @user.save
      if params[:user][:category_ids].present?
        selected_ids = params[:user][:category_ids].reject(&:blank?)
        @user.category_ids = selected_ids
      end
      session[:current_user_id] = @user.id
      redirect_to root_path, notice: "Welcome!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, category_ids: [])
  end
end
