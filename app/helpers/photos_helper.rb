require 'rmagick'
require 'base64'
require 'securerandom'
module PhotosHelper
  def saveImg(data)
    puts "11111111"
    img = Magick::Image.read_inline(data)[0]
    puts "2222222222"
    path = 'public/uploads/' + SecureRandom.hex(8) + '.' + img.format.downcase
    puts "33333333 writing"
    img.write(path)
    path
  end
end
