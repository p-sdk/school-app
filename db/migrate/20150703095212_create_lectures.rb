class CreateLectures < ActiveRecord::Migration[4.2]
  def change
    create_table :lectures do |t|
      t.string :title
      t.text :content
      t.references :course, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
