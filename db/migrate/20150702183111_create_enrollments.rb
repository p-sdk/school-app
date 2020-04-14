class CreateEnrollments < ActiveRecord::Migration[4.2]
  def change
    create_table :enrollments do |t|
      t.references :student, index: true, null: false
      t.references :course, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :enrollments, :users, column: :student_id
    add_index :enrollments, [:student_id, :course_id], unique: true
  end
end
