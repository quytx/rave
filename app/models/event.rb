class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_time, :end_time, :user_id
  belongs_to :user
  has_many :photos
  has_many :event_participants
  has_many :participants, through: :event_participants, source: :user
end
