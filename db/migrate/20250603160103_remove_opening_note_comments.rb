class RemoveOpeningNoteComments < ActiveRecord::Migration[8.0]
  def up
    safety_assured do
      execute <<-SQL.squish
        DELETE FROM note_comments WHERE event = 'opened';
      SQL
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
