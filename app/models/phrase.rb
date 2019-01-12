class Phrase < ApplicationRecord
  belongs_to :chapter, foreign_key: 'chapter_id'
  has_many :options, dependent: :destroy

end
