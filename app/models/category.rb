class Category < ApplicationRecord

  include Searchable

  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :blogs
  has_many :followers, as: :followable

  def as_indexed_json(options = {})
    self.as_json(
      only: [:name, :slug]
    )
  end

end