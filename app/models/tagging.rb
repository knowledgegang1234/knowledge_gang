class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :blog
  belongs_to :user

  def self.trending_tags(count = 20)
    joins(:tag).where('taggings.created_at::DATE >= ?', Date.today - 30.days)
      .group('tags.name').count.sort_by{ |_, value| value }.reverse.first(count).to_h
  end


end
