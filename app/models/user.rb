class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bicycles, foreign_key: :owner_id, dependent: :destroy
  has_many :rentals, foreign_key: :renter_id, dependent: :nullify
  has_many :owner_reviews, class_name: 'Review', foreign_key: 'reviewed_user_id', dependent: :nullify
  has_many :renter_reviews, class_name: 'Review', foreign_key: 'reviewer_user_id', dependent: :nullify

  before_destroy :check_active_rentals

  private

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
end