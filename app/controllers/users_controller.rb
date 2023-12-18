class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: [:show, :update, :destroy]

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
      redirect_to root_path, notice: 'Impossible de supprimer un utilisateur avec des locations en cours. Rendez-vous dans votre page profil.'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user, notice: "L'utilisateur a bien été modifié."
    else
      render :edit
    end
  end

  private

  def authorize_user
    redirect_to root_path, alert: "Accès refusé! Vous n'avez pas le droit d'accéder à cette page et/ou d'effectuer cette action." unless current_user == User.find(params[:id])
  end
end