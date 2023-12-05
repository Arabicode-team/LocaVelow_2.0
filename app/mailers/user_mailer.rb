class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user 
    
       @url  = 'http://locavelik-115195375a5a.herokuapp.com/' 
    
        mail(to: @user.email, subject: 'Bienvenue chez Locavelow !') 
      end

      def renter_confirmation_email(user, rental)
        @user = user

        @rental = rental

        mail(to: @user.email, subject: 'Confirmation de votre réservation chez Locavelow')
      end
end
