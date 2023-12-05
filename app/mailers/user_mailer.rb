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

      def renter_upcoming_reminder(rental)
        @rental = rental
        @renter = rental.renter
        @bicycle = rental.bicycle
        days_until_start = (@rental.start_date.to_date - Date.today).to_i
    
        if days_until_start == 1 && !@rental.cancelled? && !@rental.completed?
          mail(to: @renter.email, subject: "Rappel : Votre réservation sur Locavelow, c'est pour bientôt !")
        end
      end

      def owner_upcoming_reminder(rental)
        @rental = rental
        @owner_email = rental.bicycle.owner.email
        @owner = User.find_by(email: @owner_email)
        days_until_start = (@rental.start_date.to_date - Date.today).to_i
      
        if days_until_start == 1 && !@rental.cancelled? && !@rental.completed?
          mail(to: @owner.email, subject: "Rappel : La location de votre vélo sur Locavelow est prévue pour demain !")
        end
      end      
end