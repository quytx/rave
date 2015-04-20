class Event < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_many :event_participants
  has_many :participants, through: :event_participants, source: :user
end
