class Project < ApplicationRecord
  has_many :chapters, dependent: :destroy
  belongs_to :user
  validates :name, presence: true
  validates :description, length: { maximum: 140 }
  paginates_per 5
end
