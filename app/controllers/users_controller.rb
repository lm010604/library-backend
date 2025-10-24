class UsersController < ApplicationController
  include ReactProps
  def new
    @user = User.new
    build_user_props
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:current_user_id] = @user.id
      redirect_to edit_favorite_categories_path, notice: "Welcome!"
    else
      build_user_props
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def build_user_props
    @user_props = {
      form: {
        action: users_path,
        method: "post",
        name: @user.name,
        email: @user.email,
        errors: @user.errors.full_messages,
        fieldErrors: @user.errors.to_hash(true)
      },
      csrfToken: react_csrf_token
    }
  end
end
