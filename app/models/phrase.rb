class Phrase < ApplicationRecord
  belongs_to :chapter, foreign_key: 'chapter_id'
  has_many :options, dependent: :destroy

  after_update :refresh_phrase_completed_count


  #after_save ThinkingSphinx::RealTime.callback_for(:phrase)

  private

  def refresh_phrase_completed_count
    chapter.refresh_completed_count
    chapter.set_status
  end
end
