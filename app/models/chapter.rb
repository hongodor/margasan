class Chapter < ApplicationRecord
  enum status: [:not_started, :opened, :closed ]
  belongs_to :project
  belongs_to :user

  validates :name, :chapter_file, presence: true
  before_create(:set_default_status, { if: :new_record? })


  private
  def set_default_status
    self.status ||= :not_started
  end
end
