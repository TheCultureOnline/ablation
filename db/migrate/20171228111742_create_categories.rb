class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.jsonb :metadata, default: "{}"

      t.timestamps
    end
    add_index :categories, :name, unique: true
    add_index :categories, :metadata
  end
end
