class Category < ApplicationRecord

  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :blogs
  has_many :followers, as: :followable

end