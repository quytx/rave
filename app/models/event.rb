class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_time, :end_time
  belongs_to :user
  has_many :photos
  has_many :event_participants
  has_many :participants, through: :event_participants, source: :user
end
