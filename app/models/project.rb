class Project < ApplicationRecord
  has_many :chapters, dependent: :destroy
  belongs_to :user
  validates :author, :name, presence: true
end
