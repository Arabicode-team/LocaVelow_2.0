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
      
      def owner_rental_notification(owner_email, rental)
        @owner_email = owner_email
        @owner = User.find_by(email: @owner_email)

        @rental = rental

        mail(to: @owner_email, subject: 'Notification : Un de vos vélos a été loué sur Locavelow!')
      end
end
