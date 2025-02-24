# == Schema Information
#
# Table name: notes
#
#  id          :bigint           not null, primary key
#  latitude    :integer          not null
#  longitude   :integer          not null
#  tile        :bigint           not null
#  updated_at  :datetime         not null
#  created_at  :datetime         not null
#  status      :enum             not null
#  closed_at   :datetime
#  description :text             default(""), not null
#  user_id     :bigint
#  user_ip     :inet
#  version     :bigint(8)        default(1), not null
#
# Indexes
#
#  index_notes_on_description  (to_tsvector('english'::regconfig, description)) USING gin
#  notes_created_at_idx        (created_at)
#  notes_tile_status_idx       (tile,status)
#  notes_updated_at_idx        (updated_at)
#
# Foreign Keys
#
#  notes_user_id_fkey  (user_id => users.id)
#

class Note < ApplicationRecord
  include GeoRecord

  belongs_to :author, :class_name => "User", :foreign_key => "user_id", :optional => true

  has_many :old_notes, -> { order(:version) }, :inverse_of => :note

  has_many :subscriptions, :class_name => "NoteSubscription"
  has_many :subscribers, :through => :subscriptions, :source => :user

  validates :id, :uniqueness => true, :presence => { :on => :update },
                 :numericality => { :on => :update, :only_integer => true }
  validates :latitude, :longitude, :numericality => { :only_integer => true }
  validates :closed_at, :presence => true, :if => proc { :status == "closed" }
  validates :status, :inclusion => %w[open closed hidden]

  validate :validate_position

  scope :visible, -> { where.not(:status => "hidden") }
  scope :invisible, -> { where(:status => "hidden") }

  after_initialize :set_defaults

  DEFAULT_FRESHLY_CLOSED_LIMIT = 7.days

  def comments
    NoteComment.left_joins(:author)
               .where(:note_id => id, :visible => true, :users => { :status => [nil, "active", "confirmed"] })
               .order(:created_at)
  end

  def all_comments
    NoteComment.left_joins(:author).order(:created_at)
  end

  # Sanity check the latitude and longitude and add an error if it's broken
  def validate_position
    errors.add(:base, "Note is not in the world") unless in_world?
  end

  # Close a note
  def close
    self.status = "closed"
    self.closed_at = Time.now.utc
    self.version = version + 1
    save
  end

  # Reopen a note
  def reopen
    self.status = "open"
    self.closed_at = nil
    self.version = version + 1
    save
  end

  # Check if a note is visible
  def visible?
    status != "hidden"
  end

  # Check if a note is closed
  def closed?
    !closed_at.nil?
  end

  def freshly_closed?
    return false unless closed?

    Time.now.utc < freshly_closed_until
  end

  def freshly_closed_until
    return nil unless closed?

    closed_at + DEFAULT_FRESHLY_CLOSED_LIMIT
  end

  # Return the note's description
  def description
    RichText.new("text", super)
  end

  private

  # Fill in default values for new notes
  def set_defaults
    self.status = "open" unless attribute_present?(:status)
  end
end
