class Photo < ActiveRecord::Base
  mount_uploader :link, PhotoUploader
  attr_accessible :link, :user_id, :event_id
  belongs_to :user
  belongs_to :event
end
