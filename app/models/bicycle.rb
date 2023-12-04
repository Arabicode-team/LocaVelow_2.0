class Bicycle < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :rentals, dependent: :nullify
  has_many :accessories, dependent: :destroy

  enum bicycle_type: { road_bike: 0, mountain_bike: 1, hybrid_bike: 2,
    city_bike: 3, bmx: 4, tandem: 5, electric_bike: 6, folding_bike: 7,
    recumbent_bike: 8, cruiser_bike: 9, cargo_bike: 10, fixed_gear_bike: 11,
    touring_bike: 12, tricycle: 13, unicycle: 14 }

  enum size: { small: 0, medium: 1, large: 2, extra_large: 3, kids: 4, other: 5 }

  before_destroy :check_active_rentals

  private

  def check_active_rentals
    if rentals.where.not(rental_status: "completed").exists?
      errors.add(:base, "Cannot delete bicycle with active rentals.")
      throw :abort
    end
  end
end
