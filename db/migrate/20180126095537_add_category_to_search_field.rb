class AddCategoryToSearchField < ActiveRecord::Migration[5.1]
  def change
    add_reference :search_fields, :category, foreign_key: true, null: true
  end
end
