class Chapter < ApplicationRecord
  enum status: [:opened, :active, :closed]
  has_many :phrases, dependent: :destroy
  belongs_to :project
  belongs_to :user

  validates :chapter_file, presence: true

  has_one_attached :chapter_file
  before_save :ensure_name_has_a_value

  private
  def ensure_name_has_a_value
    self.filename = chapter_file.filename
    if name.nil?
      self.name = filename unless filename.blank?
    end
  end
end