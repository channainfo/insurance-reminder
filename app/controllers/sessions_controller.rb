class SessionsController < ApplicationController
  layout "sign_in"

  skip_before_action :authenticate_user!, except: [:destroy]

  def new
    if user_signed_in?
      redirect_to after_signed_in_path_for(current_user), notice: "You already signed in"
    end
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      redirect_to sign_in_and_redirect_for(user), notice: "Signed in successfully"
    else
      flash.now[:alert] = "Invalid username/password"
      render :new
    end
  end

  def destroy
    redirect_to sign_out_and_redirect_for(current_user), notice: "You have been signed out"
  end
end
