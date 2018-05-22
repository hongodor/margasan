class Option < ApplicationRecord
  belongs_to :user
  belongs_to :phrase
end
