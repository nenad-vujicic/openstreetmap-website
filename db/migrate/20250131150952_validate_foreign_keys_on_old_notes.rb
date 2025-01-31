class ValidateForeignKeysOnOldNotes < ActiveRecord::Migration[7.2]
  def change
    validate_foreign_key :old_notes, :users
    validate_foreign_key :old_notes, :notes
  end
end
