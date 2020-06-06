class CreateSolutions < ActiveRecord::Migration[4.2]
  def change
    create_table :solutions do |t|
      t.references :enrollment, index: true, null: false, foreign_key: true
      t.references :task, index: true, null: false, foreign_key: true
      t.text :content
      t.integer :earned_points

      t.timestamps null: false
    end

    add_index :solutions, %i[enrollment_id task_id], unique: true
  end
end
