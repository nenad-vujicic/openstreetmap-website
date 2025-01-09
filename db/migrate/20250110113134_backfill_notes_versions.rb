class BackfillNotesVersions < ActiveRecord::Migration[7.2]
  class Note < ApplicationRecord; end
  class NoteComment < ApplicationRecord; end

  def change
    all_statuses = %w[opened reopened closed hidden].freeze
    open_statuses = %w[opened reopened].freeze

    Note.in_batches(:of => 1000) do |notes|
      note_ids = notes.pluck(:id)
      groups_of_comments = NoteComment.where(:note_id => note_ids).order(:created_at).group_by(&:note_id)

      values = notes.filter_map do |note|
        version = 1
        comments = groups_of_comments[note.id]
        comments.filter_map do |comment|
          if all_statuses.include?(comment.event)
            new_status = open_statuses.include?(comment.event) ? "open" : comment.event
            "(#{note.id}, #{note.latitude}, #{note.longitude}, #{note.tile}, '#{comment.created_at}', '#{new_status}'::note_status_enum, #{version})".tap { version += 1 }
          end
        end
      end.join(", ")

      unless values.empty?
        sql = "INSERT INTO old_notes (note_id, latitude, longitude, tile, timestamp, status, version) VALUES #{values}"
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
