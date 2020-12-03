class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :blog
  belongs_to :user

  def self.trending_tags
    joins(:tag).where('taggings.created_at::DATE >= ?', Date.today - 30.days)
      .group('tags.name').count.sort_by{ |_, value| value }.reverse.first(20).to_h
  end


end
