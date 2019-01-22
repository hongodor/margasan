class Phrase < ApplicationRecord
  belongs_to :chapter, foreign_key: 'chapter_id'
  has_many :options, dependent: :destroy


  after_save ThinkingSphinx::RealTime.callback_for(:phrase)
end
