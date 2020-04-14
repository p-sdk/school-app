class AddAttachmentToLectures < ActiveRecord::Migration[4.2]
  def self.up
    change_table :lectures do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :lectures, :attachment
  end
end
