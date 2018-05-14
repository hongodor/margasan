class Project < ApplicationRecord
  has_many :chapters, dependent: :destroy
  belongs_to :user
  validates :author, :name, presence: true
  paginates_per 5
end
