class Blog < ApplicationRecord

  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :category
  has_many :comments
  has_many :likes
  has_many :taggings

  after_save :process_description

  private

  def process_description
    short_desc = ActionView::Base.full_sanitizer.sanitize(description).first(200) + ' .....'
    update_column(:short_description, short_desc)
  end

end