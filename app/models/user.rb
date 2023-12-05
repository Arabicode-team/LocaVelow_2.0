class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bicycles, foreign_key: :owner_id, dependent: :destroy
  has_many :rentals, foreign_key: :renter_id #, dependent: :nullify
  has_many :owner_reviews, class_name: 'Review', foreign_key: 'reviewed_user_id', dependent: :nullify
  has_many :renter_reviews, class_name: 'Review', foreign_key: 'reviewer_user_id', dependent: :nullify

  before_destroy :check_active_rentals

  before_destroy :nullify_rentals

  private

  def check_active_rentals
    if bicycles.any? { |bicycle| bicycle.rentals.where.not(rental_status: "completed").exists? }
      errors.add(:base, "Cannot delete user with active rentals.")
      throw :abort
    end

    if rentals.where.not(rental_status: "completed").exists?
      errors.add(:base, "Cannot delete user with active rentals.")
      throw :abort
    end
  end

  def nullify_rentals
    rentals.update_all(renter_id: nil)
  end

end
