class CreateCategoryMetadata < ActiveRecord::Migration[5.1]
  def change
    create_table :category_metadata do |t|
      t.string :name
      t.integer :data_type
      t.integer :sort_order
      t.string :default
      t.boolean :optional, default: false
      t.jsonb :options
      t.text :description
      t.references :category, foreign_key: true

      t.timestamps
    end
    add_index :category_metadata, [:id, :sort_order]
  end
end
