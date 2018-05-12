class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :status, default: 0
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :chapter_file_data
      t.string :filename
      t.integer :completed_phrases_count

      t.timestamps null: false
    end
  end
end
