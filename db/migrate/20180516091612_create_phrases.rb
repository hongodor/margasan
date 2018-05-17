class CreatePhrases < ActiveRecord::Migration[5.2]
  def change
    create_table :phrases do |t|
      t.text :original
      t.text :translated
      t.references :chapter, index: true, foreign_key: true

      t.timestamps
    end
  end
end
