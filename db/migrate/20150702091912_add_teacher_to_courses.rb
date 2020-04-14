class AddTeacherToCourses < ActiveRecord::Migration[4.2]
  def change
    add_reference :courses, :teacher, index: true
    add_foreign_key :courses, :users, column: :teacher_id
  end
end
