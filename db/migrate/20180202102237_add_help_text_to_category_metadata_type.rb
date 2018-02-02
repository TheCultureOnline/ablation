class AddHelpTextToCategoryMetadataType < ActiveRecord::Migration[5.1]
  def change
    add_column :category_metadata_types, :help_text, :text
  end
end
