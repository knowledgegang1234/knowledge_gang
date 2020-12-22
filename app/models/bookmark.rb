class Bookmark < ApplicationRecord

  belongs_to :user
  belongs_to :blog

  scope :active, -> {where(active: true)}

end