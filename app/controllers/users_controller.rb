class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  def new
    redirect_to root_path if authenticated?

    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
