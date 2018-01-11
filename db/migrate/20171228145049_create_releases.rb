class CreateReleases < ActiveRecord::Migration[5.1]
  def change
    create_table :releases do |t|
      t.string :name, null: false
      t.integer :year
      t.text :description
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
