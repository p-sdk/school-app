class AddConfirmableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      t.index    :confirmation_token, unique: true
    end

    User.update_all(confirmed_at: Time.zone.now)
  end
end
