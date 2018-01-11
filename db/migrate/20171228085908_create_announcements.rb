class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.text :title, null: false
      t.text :body, null: false
      t.boolean :pinned, null: false, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
