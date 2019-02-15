class AddEventIdToPhrases < ActiveRecord::Migration[5.2]
  def change
    add_column :phrases, :event_id, :integer
  end
end
