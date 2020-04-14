class AddTeacherToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :teacher, :boolean, default: false
  end
end
