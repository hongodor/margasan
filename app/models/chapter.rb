class Chapter < ApplicationRecord
  enum status: [:not_started, :opened, :closed ]
  belongs_to :project
  belongs_to :user

  validates :name, presence: true

  has_one_attached :chapter_file

  private

end
