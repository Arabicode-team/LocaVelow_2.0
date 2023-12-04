class Review < ApplicationRecord
  belongs_to :rental, optional: true
  belongs_to :reviewed_user, class_name: 'User', optional: true
  belongs_to :reviewer_user, class_name: 'User', optional: true
end
