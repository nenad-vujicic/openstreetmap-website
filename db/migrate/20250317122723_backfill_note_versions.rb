class BackfillNoteVersions < ActiveRecord::Migration[7.2]
  class NoteVersion < ApplicationRecord; end

  class Note < ApplicationRecord
    has_many :note_comments

    def all_comments
      note_comments
    end
  end

  class NoteComment < ApplicationRecord; end

  disable_ddl_transaction!

  def up
    NoteVersion.delete_all

    Note.find_each do |note|
      opening_events = %w[opened reopened]

      version = 1
      the_latest_note_version = nil
      note.all_comments.each do |comment|
        if opening_events.include?(comment.event)
          the_latest_note_version = create_note_version_from(note, comment.created_at, "open", version)
          version += 1
        elsif comment.event == "closed"
          the_latest_note_version = create_note_version_from(note, comment.created_at, "closed", version)
          version += 1
        elsif comment.event == "hidden"
          the_latest_note_version.status = "hidden" unless the_latest_note_version.nil?
        end
      end
    end
  end

  def down
    NoteVersion.delete_all
  end

  private

  def create_note_version_from(note, timestamp, status, version)
    NoteVersion.create!(
      :note_id => note.id,
      :latitude => note.latitude,
      :longitude => note.longitude,
      :tile => note.tile,
      :timestamp => timestamp,
      :status => status,
      :description => note.description,
      :user_id => note.user_id,
      :user_ip => note.user_ip,
      :version => version
    )
  end
end
