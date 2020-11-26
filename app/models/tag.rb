class Tag < ApplicationRecord

  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :taggings
  has_many :followers, as: :followable

end