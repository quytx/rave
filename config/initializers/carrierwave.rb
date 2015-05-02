require "carrierwave"
require "carrierwave/orm/activerecord"

CarrierWave.configure do |config|
  config.storage = :fog       
  config.root = Rails.root.join('tmp') # adding these...
  config.cache_dir = 'carrierwave' # ...two lines                 
  config.fog_credentials = {
    provider:              'AWS',                        
    aws_access_key_id:     ENV['S3_ACCESS_KEY'],                      
    aws_secret_access_key: ENV['S3_SECRET_KEY'],                        
    region:                'us-west-2',
  }
  config.fog_directory  = 'cs407rave'                          
end