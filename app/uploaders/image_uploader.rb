class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  version :thumbnail do
    resize_to_fit(55, 55)
  end

  def public_id
    name = Cloudinary::PreloadedFile.split_format(original_filename).first + "_" + Cloudinary::Utils.random_public_id[0,6]
    return "linkisin/#{Rails.env}/#{model.class.to_s.underscore}/#{name}"
  end

  # for image size validation
  # fetching dimensions in uploader, validating it in model
  attr_reader :width, :height
  before :cache, :capture_size
  def capture_size(file)
    if version_name.blank? # Only do this once, to the original version
      if file.path.nil? # file sometimes is in memory
        img = ::MiniMagick::Image::read(file.file)
        @width = img[:width]
        @height = img[:height]
      else
        @width, @height = `identify -format "%wx %h" #{file.path}`.split(/x/).map{|dim| dim.to_i }
      end
    end
  end
end