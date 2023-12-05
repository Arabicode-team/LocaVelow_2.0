class UsersController < ApplicationController

  def show
    @user = current_user
  end
  
  def destroy
    if current_user.destroy
      redirect_to root_path, notice: 'Your profile was successfully deleted.'
    else
      redirect_to root_path, notice: 'Cannot delete user with active rentals.' #current_user.errors.full_messages.to_sentence
    end
  end
  
end