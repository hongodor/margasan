class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.string :content
      t.string :author
      t.references :user, index: true, foreign_key: true
      t.references :phrase, index:true, foreign_key: true

      t.timestamps
    end
  end
end
