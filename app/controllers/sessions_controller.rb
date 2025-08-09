class SessionsController < ApplicationController
  def new; end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      session[:current_user_id] = user.id
      redirect_to(session.delete(:return_to) || root_url)
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end


  def destroy
    session.delete(:current_user_id)
    @current_user = nil
    redirect_to root_url, status: :see_other
  end
end
