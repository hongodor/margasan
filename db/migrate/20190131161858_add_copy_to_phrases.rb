class AddCopyToPhrases < ActiveRecord::Migration[5.2]
  def change
    add_column :phrases, :copy, :integer, default: 0
  end
end
