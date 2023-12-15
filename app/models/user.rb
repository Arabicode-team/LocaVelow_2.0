class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bicycles, foreign_key: :owner_id, dependent: :destroy
  has_many :rentals, foreign_key: :renter_id #, dependent: :nullify
  has_many :owner_reviews, class_name: 'Review', foreign_key: 'reviewed_user_id', dependent: :nullify
  has_many :renter_reviews, class_name: 'Review', foreign_key: 'reviewer_user_id', dependent: :nullify

  has_one_attached :image

  before_destroy :check_active_rentals

  before_destroy :nullify_rentals
  def thumbnail
    return self.image.variant(resize_to_limit: [150, 150]).processed
  end

  after_create :welcome_send

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  private

  def check_active_rentals
    if bicycles.any? { |bicycle| bicycle.rentals.exists? }
      errors.add(:base, "Impossible de supprimer votre profil pour l'instant car vous avez encore des annonces en ligne. Merci de bien vouloir nous contacter pour procéder à la suppression de votre compte.")
      throw :abort
    end
  
    if rentals.exists?
      errors.add(:base, "Impossible de supprimer votre profil pour l'instant car il a des locations en cours/effectuées. Merci de bien vouloir nous contacter pour procéder à la suppression de votre compte.")
      throw :abort
    end
  end

  def nullify_rentals
    rentals.update_all(renter_id: nil)
  end

end