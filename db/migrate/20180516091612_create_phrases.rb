class CreatePhrases < ActiveRecord::Migration[5.2]
  def change
    create_table :phrases do |t|
      t.string :original
      t.string :translated, default: ""
      t.boolean :check, default: false
      t.references :chapter, index: true, foreign_key: true

      t.timestamps
    end
  end
end
