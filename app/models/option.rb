class Option < ApplicationRecord
  belongs_to :user
  belongs_to :phrase
  validates :content, presence: true
  after_commit { OptionRelayJob.perform_later(self) }
end
