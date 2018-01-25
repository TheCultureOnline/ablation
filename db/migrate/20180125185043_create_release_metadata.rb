class CreateReleaseMetadata < ActiveRecord::Migration[5.1]
  def change
    create_table :release_metadata do |t|
      t.references :release, foreign_key: true
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
