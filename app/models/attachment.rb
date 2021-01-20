class Attachment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :attachable, :polymorphic => true, optional: true
  
  has_attached_file :photo,
                    :styles => { :medium => "400x400>",
                    :small => "100x100>",
                    :thumb => "40x40>" },
                    :storage => :s3,
                    :s3_region => 'us-east-1',
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "attachments/:attachment/:id/:style/:basename.:extension",
                    :s3_host_alias => AppConfig.cdn['url'],
                    :url => ':s3_alias_url',
                    :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
                    :s3_protocol => :https
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates :photo_file_name, :presence => true
end