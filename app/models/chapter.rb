class Chapter < ApplicationRecord
  enum status: { active: 0, closed: 1 }
  has_many :phrases, -> { order(:id => :asc) }, dependent: :destroy
  belongs_to :project
  belongs_to :user

  validates :chapter_file, presence: true

  has_one_attached :chapter_file
  before_save :ensure_name_has_a_value

  def refresh_completed_count
    update_columns(completed_phrases_count: phrases.where(check: true).size)
  end

  def set_status
    if completed_phrases_count == phrases_count
      update_columns(status: 1)
    end
  end

  private
  def ensure_name_has_a_value
    self.filename = chapter_file.filename
    if name.nil?
      self.name = filename unless filename.blank?
    end
  end
end