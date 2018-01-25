class CreateCategoryMetadataTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :category_metadata_types do |t|
      t.string :name, null: false
      t.integer :field_type, null: false
      t.integer :metadata_for, null: false
      t.references :category, foreign_key: true
      t.text :options, array: true

      t.timestamps
    end
  end
end
