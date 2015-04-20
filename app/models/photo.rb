class Photo < ActiveRecord::Base
  mount_uploader :link, PhotoUploader
  belongs_to :user
  belongs_to :event
end
