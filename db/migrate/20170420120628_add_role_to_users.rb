class AddRoleToUsers < ActiveRecord::Migration
  def up
    add_column :users, :role, :integer, default: 0

    execute <<~SQL
      UPDATE users
        SET role = 0
        WHERE teacher = false
    SQL

    execute <<~SQL
      UPDATE users
        SET role = 1
        WHERE teacher = true
    SQL

    remove_column :users, :teacher
  end

  def down
    add_column :users, :teacher, :boolean, default: false

    execute <<~SQL
      UPDATE users
        SET teacher = false
        WHERE role = 0
    SQL

    execute <<~SQL
      UPDATE users
        SET teacher = true
        WHERE role = 1
    SQL

    remove_column :users, :role
  end
end
