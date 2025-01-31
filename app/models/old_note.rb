# == Schema Information
#
# Table name: old_notes
#
#  note_id     :bigint(8)        not null, primary key
#  latitude    :integer          not null
#  longitude   :integer          not null
#  tile        :bigint(8)        not null
#  timestamp   :datetime         not null
#  status      :enum             not null
#  description :text             default(""), not null
#  user_id     :bigint(8)
#  user_ip     :inet
#  version     :bigint(8)        default(1), not null, primary key
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
end
