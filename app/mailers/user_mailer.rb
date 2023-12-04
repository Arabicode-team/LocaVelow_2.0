class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user 
    
=        @url  = 'https://locavelow-70268798a3e1.herokuapp.com/' 
    
        mail(to: @user.email, subject: 'Bienvenue chez Locavelow !') 
      end
end
