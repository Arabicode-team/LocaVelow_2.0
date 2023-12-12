class UsersController < ApplicationController

  def show
    @user = current_user
  end
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :description, :image)
  end
  
  def destroy
    if current_user.destroy
      redirect_to root_path, notice: 'Votre compte a bien été supprimé'
    else
      redirect_to root_path, notice: 'Impossible de supprimer un utilisateur avec des locations actives'
    end
  end
  def update
    @user = User.find(params[:id])
  
    if @user.update(user_params)
      redirect_to @user, notice: "L'utilisateur a bien été modifié"
    else
      render :edit
    end
  end
  
end