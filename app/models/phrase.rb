class Phrase < ApplicationRecord
  belongs_to :chapter, counter_cache: true, foreign_key: 'chapter_id'
  has_many :options, dependent: :destroy


end
