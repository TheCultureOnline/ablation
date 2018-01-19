class CreateSearchFields < ActiveRecord::Migration[5.1]
  def change
    create_table :search_fields do |t|
      t.text :name, null: false
      t.text :title
      t.integer :kind, null: false, default: 0
      t.text :options, array: true
      t.integer :sort_order, null: false
      t.jsonb :misc, default: "{}"

      t.timestamps
    end
  end
end
