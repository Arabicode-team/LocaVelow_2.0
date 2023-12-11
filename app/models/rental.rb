class Rental < ApplicationRecord
  belongs_to :bicycle, optional: true
  belongs_to :renter, class_name: 'User'
  has_one :owner_review, ->(rental) { where(reviewer_user: rental.bicycle&.owner) },
    class_name: 'Review', foreign_key: 'rental_id', dependent: :destroy
  has_one :renter_review, ->(rental) { where(reviewer_user: rental.renter) },
    class_name: 'Review', foreign_key: 'rental_id', dependent: :destroy

  enum rental_status: { in_progress: 0, completed: 1, cancelled: 2 }

  validate :date_not_already_booked, on: :create
  validate :date_not_in_past, on: :create


  after_create :send_renter_confirmation_email
  after_create :send_owner_confirmation_email
  after_create :renter_schedule_upcoming_reminder
  after_create :owner_schedule_upcoming_reminder

  def calculate_total_cost
    return 0 unless start_date && end_date && bicycle && bicycle.price_per_hour

    duration_hours = (end_date - start_date) / 1.hour
    total_cost = duration_hours * bicycle.price_per_hour

    total_cost
  end

  def update_status_for_past_rentals
    if end_date.present? && end_date < DateTime.now && rental_status != 'cancelled'
      update(rental_status: :completed)
    end
  end

  def refundable?
    return false if rental_status.in?(['cancelled', 'completed'])
    return false if start_date - 48.hours <= DateTime.now
  
    true
  end  

  def send_renter_confirmation_email
    UserMailer.renter_confirmation_email(User.find(self.renter_id), self).deliver_now
  end

  def send_owner_confirmation_email
    owner_email = bicycle.owner.email
    UserMailer.owner_rental_notification(owner_email, self).deliver_now
  end

  def renter_schedule_upcoming_reminder
    UserMailer.renter_upcoming_reminder(self).deliver_later
  end

  def owner_schedule_upcoming_reminder
    UserMailer.owner_upcoming_reminder(self).deliver_later
  end

  def process_successful_refund
    return unless stripe_refund_id.present?
    return unless rental_status == 'cancelled'

    UserMailer.renter_cancellation_and_refund_confirmation(self).deliver_now
    UserMailer.owner_cancellation_and_refund_confirmation(self).deliver_now
  end
  
  private

  def date_not_already_booked
    overlapping_rentals = Rental.where(bicycle_id: bicycle_id)
                                .where.not(id: id)
                                .where('start_date < ? AND end_date > ?', end_date, start_date)
    if overlapping_rentals.exists?
      errors.add(:base, 'Le vélo a déjà été reservé pour ces dates.')
    end
  end

  def date_not_in_past
    if start_date.present? && start_date < Date.current
      errors.add(:start_date, "La date de début de la location ne peut pas être dans le passé.")
    end

    if end_date.present? && end_date < Date.current
      errors.add(:end_date, "La date de fin de la location ne peut pas être dans le passé.")
    end
  end
end