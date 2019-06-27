class CreateRepeats < ActiveRecord::Migration[5.2]
  def change
    create_table :repeats do |t|
      t.string :phrase
      t.string :translation
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
