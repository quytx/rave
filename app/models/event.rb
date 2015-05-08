class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_time, :end_time, :user_id, :description
  belongs_to :user
  has_many :photos
  has_many :event_participants
  has_many :participants, through: :event_participants, source: :user

  def guest_count
    self.participants.all.count
  end

  def st
    self.start_time.in_time_zone("Central Time (US & Canada)").to_formatted_s(:long)
  end

  def et
    self.end_time.in_time_zone("Central Time (US & Canada)").to_formatted_s(:long)
  end

  def as_json(options={})
    super.as_json({except: :start_time, except: :end_time}).merge({:participant_count => guest_count, :start_time => st, :end_time => et})
  end
end
