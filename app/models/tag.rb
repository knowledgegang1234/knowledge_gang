class Tag < ApplicationRecord

  include Searchable

  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :taggings
  has_many :followers, as: :followable
  has_many :blogs, through: :taggings

  def as_indexed_json(options = {})
    self.as_json(
      only: [:name, :slug]
    )
  end

end