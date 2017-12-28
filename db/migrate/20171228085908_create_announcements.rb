class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.text :title
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
