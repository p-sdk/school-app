class AddTeacherToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :teacher, index: true
    add_foreign_key :courses, :users, column: :teacher_id
  end
end
