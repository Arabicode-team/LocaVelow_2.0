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

  private

  def check_active_rentals
    if bicycles.any? { |bicycle| bicycle.rentals.where(rental_status: "in_progress").exists? }
      errors.add(:base, "Cannot delete user with pending rentals.")
      throw :abort
    end
  
    if rentals.where(rental_status: "in_progress").exists?
      errors.add(:base, "Cannot delete user with pending rentals.")
      throw :abort
    end
  end

  def nullify_rentals
    rentals.update_all(renter_id: nil)
  end

end