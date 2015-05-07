class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_time, :end_time, :user_id, :description
  belongs_to :user
  has_many :photos
  has_many :event_participants
  has_many :participants, through: :event_participants, source: :user

  # def guest_count
  #   self.participants.all.count
  # end

  # def as_json(options={})
  #   super.as_json(options).merge({:participant_count => guest_count})
  # end
end
