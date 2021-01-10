class Blog < ApplicationRecord

  include Searchable

  extend FriendlyId

  friendly_id :title, use: :slugged

  after_commit on: [:create, :update] do
    es_reindex
  end

  after_commit on: [:destroy] do
    es_delete_index
  end

  belongs_to :user
  belongs_to :category
  has_many :comments
  has_many :likes
  has_many :taggings
  has_many :tags, through: :taggings

  after_save :process_description
  after_create :update_blogs_count

  enum status: {draft: 0, live: 1}

  default_scope {where.not(status: 0)}

  def self.trending_blogs
    trending_days = 140
    where('created_at::DATE >= ?', Date.today - trending_days.days).order(likes_count: :desc)
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :description, :slug]
    )
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