class RemoveEventFromNoteComments < ActiveRecord::Migration[7.2]

  disable_ddl_transaction!

  def change
    # Remove all records with event set to 'opened'
    NoteComment.where(:event => "opened").delete_all

    # Remove all records with description set to nil or empty string
    NoteComment.where(:description => [nil, ""]).delete_all

    # Remove the column 'event'
    remove_column :note_comments, :event
  end
end
