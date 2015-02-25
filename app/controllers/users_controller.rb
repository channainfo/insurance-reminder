class UsersController < ApplicationController
  def index
    @users = User.except(current_user).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new protected_params
    if @user.save
      redirect_to users_path, notice: 'User has been created'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path, notice: 'User has been deleted'
    else
      redirect_to users_path, alert: "Fail to delete #{@user.name}"
    end
  end

  private

  def protected_params
    params.require(:user).permit(:username, :password, :password_confirmation, :role, :name)
  end

end
