class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :published, inclusion: { in: [true, false] } # Boolean data validation
  validates :user_id, presence: true
end
