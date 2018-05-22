class Chapter < ApplicationRecord
  enum status: [:opened, :active, :closed]
  has_many :phrases, dependent: :destroy
  belongs_to :project
  belongs_to :user

  validates :name, presence: true
  validates :chapter_file, presence: true
  validates :filename, presence: true

  has_one_attached :chapter_file

end
