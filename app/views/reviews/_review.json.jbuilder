json.extract! review, :id, :rental_id, :reviewed_user_id, :reviewer_user_id, :rating, :review_text, :review_date, :created_at, :updated_at
json.url review_url(review, format: :json)
