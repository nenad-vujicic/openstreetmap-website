# == Schema Information
#
# Table name: old_notes
#
#  note_id   :bigint(8)        not null
#  latitude  :integer          not null
#  longitude :integer          not null
#  tile      :bigint(8)        not null
#  timestamp :datetime         not null
#  status    :enum             not null
#  version   :bigint(8)        default(1), not null
#
# Indexes
#
#  index_old_notes_on_tile       (tile)
#  index_old_notes_on_timestamp  (timestamp)
#

class OldNote < ApplicationRecord
  validates :id, :uniqueness => true, :presence => { :on => :update },
                 :numericality => { :on => :update, :only_integer => true }
  validates :latitude, :longitude, :numericality => { :only_integer => true }
  validates :status, :inclusion => %w[open closed hidden]

  validate :validate_position

  scope :visible, -> { where.not(:status => "hidden") }
  scope :invisible, -> { where(:status => "hidden") }

  after_initialize :set_defaults

  # Sanity check the latitude and longitude and add an error if it's broken
  def validate_position
    errors.add(:base, "Note is not in the world") unless in_world?
  end

  private

  # Fill in default values for new notes
  def set_defaults
    self.status = "open" unless attribute_present?(:status)
  end
end
