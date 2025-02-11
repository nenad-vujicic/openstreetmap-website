# == Schema Information
#
# Table name: old_notes
#
#  note_id     :bigint           not null, primary key
#  latitude    :integer          not null
#  longitude   :integer          not null
#  tile        :bigint           not null
#  timestamp   :datetime         not null
#  status      :enum             not null
#  description :text             default(""), not null
#  user_id     :bigint
#  user_ip     :inet
#  version     :bigint           default(1), not null, primary key
#
# Indexes
#
#  index_old_notes_on_version  (version)
#
# Foreign Keys
#
#  old_notes_note_id_fkey  (note_id => notes.id)
#  old_notes_user_id_fkey  (user_id => users.id)
#

class OldNote < ApplicationRecord
  belongs_to :author, :class_name => "User", :foreign_key => "user_id", :optional => true, :inverse_of => :old_notes
  belongs_to :note, :class_name => "Note", :inverse_of => :old_notes

  def self.from_note(note, timestamp)
    OldNote.create(
      :note_id => note.id,
      :latitude => note.latitude,
      :longitude => note.longitude,
      :tile => note.tile,
      :timestamp => timestamp,
      :status => note.status,
      :description => note.description,
      :user_id => note.user_id,
      :user_ip => note.user_ip,
      :version => note.version
    )
  end
end
