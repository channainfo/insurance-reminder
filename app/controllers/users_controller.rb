class UsersController < ApplicationController
  def index
    @users = User.get_involved_users(current_user)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new protected_params
    errors_org = validate_existing Organization, [params[:user]["organizations"]], params[:user]["role"]
    errors_od = validate_existing OperationalDistrict, [params[:user]["ods"]], params[:user]["role"]
    if errors_org["status"] and errors_od["status"]
      if @user.save
        redirect_to users_path, notice: 'User has been created'
      else
        render :new
      end
    else
      errors_org["errors"].each do |error|
        @user.errors.add(:ods, error)
      end
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(protected_basic_params)
      redirect_to users_path, notice: 'User has been updated'
    else
      render :edit
    end
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

  def validate_existing model, list, role
    users = User.where("role =?", User::ROLE_OPERATOR)
    result = {}
    result["errors"] = []
    result["status"] = true
    return result unless list || role != User::ROLE_OPERATOR
    users.each do |u|
      list.each do |o|
        if u.ods.include? o
          od = model.find(o.to_i)
          result["errors"].push(" #{od.name} was owned by #{u.name}")
          result["status"] = false
        end
      end
    end
    return result
  end

  def protected_params
    params.require(:user).permit(:username, :password, :password_confirmation, :role, :name, :ods => [], :organizations => [])
  end

  def protected_basic_params
    params.require(:user).permit(:password, :password_confirmation, :role, :name, :ods => [], :organizations => [])
  end

end
