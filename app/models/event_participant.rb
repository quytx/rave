class EventParticipant < ActiveRecord::Base
  attr_accessible :user_id, :event_id
  belongs_to :event
  belongs_to :user
end
