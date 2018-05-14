class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :status, default: 0
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :filename
      t.integer :phrases_count
      t.integer :completed_phrases_count, default: 0

      t.timestamps null: false
    end
  end
end
