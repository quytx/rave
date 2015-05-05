require 'rmagick'
require 'base64'
require 'securerandom'
module PhotosHelper
  def saveImg(data)
    img = Magick::Image.read_inline(data)[0]
    path = "#{Rails.root}/tmp/" + SecureRandom.hex(8) + '.' + img.format.downcase
    img.write(path)
    path
  end
end
