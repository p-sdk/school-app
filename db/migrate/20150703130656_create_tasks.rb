class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :desc
      t.integer :points
      t.references :course, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
