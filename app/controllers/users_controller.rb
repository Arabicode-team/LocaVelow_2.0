class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  def show
    @user = current_user
  end
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :description, :image)
  end
  
  def destroy
    if current_user.destroy
      redirect_to root_path, notice: 'Your profile was successfully deleted.'
    else
      redirect_to root_path, notice: 'Cannot delete user with active rentals.'
    end
  end
  def update
    @user = User.find(params[:id])
  
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def authorize_user
    redirect_to root_path, alert: 'Accès refusé!' unless current_user == User.find(params[:id])
  end
  
end