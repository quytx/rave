class User < ActiveRecord::Base
  has_secure_password
  has_many :events
  has_many :event_participants
  has_many :attended_events, through: :event_participants, source: :event
  has_many :photos
end
