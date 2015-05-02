class Photo < ActiveRecord::Base
  mount_uploader :url, PhotoUploader
  attr_accessible :url, :user_id, :event_id
  belongs_to :user
  belongs_to :event
end
