class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user 
    
       @url  = 'http://locavelik-115195375a5a.herokuapp.com/' 
    
        mail(to: @user.email, subject: 'Bienvenue chez Locavelow !') 
      end
end
