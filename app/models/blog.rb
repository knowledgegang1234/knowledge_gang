class Blog < ApplicationRecord

  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :category
  has_many :comments
  has_many :likes
  has_many :taggings

end