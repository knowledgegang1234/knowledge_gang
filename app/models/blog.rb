class Blog < ApplicationRecord

  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :category
  has_many :comments
  has_many :likes
  has_many :taggings
  has_many :tags, through: :taggings

  after_save :process_description
  after_create :update_blogs_count

  def self.trending_blogs
    trending_days = 140
    where('created_at::DATE >= ?', Date.today - trending_days.days).order(likes_count: :desc)
  end

  private

  def process_description
    short_desc = ActionView::Base.full_sanitizer.sanitize(description).first(200) + ' .....'
    update_column(:short_description, short_desc)
  end

  def update_blogs_count
    category.update_column(:blogs_count, category.blogs.count)
  end

end