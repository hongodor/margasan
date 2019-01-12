class Project < ApplicationRecord
  has_many :chapters, dependent: :destroy
  belongs_to :user
  validates :name, presence: true

end
