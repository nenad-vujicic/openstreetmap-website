class AddNotesVersions < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :version, :bigint, :null => false, :default => 1

    create_table :old_notes, :id => false, :primary_key => [:note_id, :version] do |t|
      t.bigint :note_id, :null => false
      t.integer :latitude, :null => false
      t.integer :longitude, :null => false
      t.bigint :tile, :null => false
      t.datetime :timestamp, :null => false
      t.column :status, "note_status_enum", :null => false
      t.bigint :version, :null => false, :default => 1
    end

    add_index :old_notes, :tile
    add_index :old_notes, :timestamp
  end
end
