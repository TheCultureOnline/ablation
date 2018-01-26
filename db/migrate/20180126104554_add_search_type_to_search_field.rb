class AddSearchTypeToSearchField < ActiveRecord::Migration[5.1]
  def change
    add_column :search_fields, :search_type, :integer, default: 0, null: false
  end
end
