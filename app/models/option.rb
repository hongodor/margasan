class Option < ApplicationRecord
  belongs_to :user
  belongs_to :phrase

  after_commit { OptionRelayJob.perform_later(self) }
end
