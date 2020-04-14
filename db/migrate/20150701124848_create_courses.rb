class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :desc

      t.timestamps null: false
    end
  end
end
