class AddNotesVersions < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :version, :bigint, :null => false, :default => 1

    create_table :old_notes, :primary_key => [:note_id, :version] do |t|
      t.bigint :note_id, :null => false
      t.integer :latitude, :null => false
      t.integer :longitude, :null => false
      t.bigint :tile, :null => false
      t.datetime :timestamp, :null => false
      t.column :status, "public.note_status_enum", :null => false
      t.text :description, :null => false, :default => ""
      t.bigint :user_id
      t.inet :user_ip
      t.bigint :version, :null => false, :default => 1
    end

    add_foreign_key :old_notes, :users, :column => :user_id, :name => "old_notes_user_id_fkey", :validate => false
    add_foreign_key :old_notes, :notes, :column => :note_id, :name => "old_notes_note_id_fkey", :validate => false

    add_index :old_notes, :version
  end
end
