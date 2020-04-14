class AddUpgradeRequestToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :upgrade_request_sent_at, :datetime

    execute <<~SQL
      UPDATE users
        SET upgrade_request_sent_at = datetime('now'), teacher = false
        WHERE teacher IS NULL
    SQL
  end

  def down
    execute <<~SQL
      UPDATE users
        SET teacher = NULL
        WHERE upgrade_request_sent_at IS NOT NULL
        AND teacher = false
    SQL

    remove_column :users, :upgrade_request_sent_at
  end
end
