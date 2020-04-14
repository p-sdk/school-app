class AddCategoryToCourses < ActiveRecord::Migration[4.2]
  def change
    add_reference :courses, :category, index: true, foreign_key: true
  end
end
