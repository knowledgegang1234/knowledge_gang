class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :blog
  belongs_to :user

  def self.trending_tags(count = 20)
    joins(:tag).where('taggings.created_at::DATE >= ?', Date.today - 30.days).group('tags.name').count.sort_by{ |_, value| value }.reverse.first(count).to_h
  end

  def self.home_tags(count=4)
    home_tags_list = {}
    trending_tags(count).each do |key, value|
      current_tag = Tag.select('id,slug').find_by(name: key)
      home_tags_list[key] = {blog_count: value, followers_count: current_tag.followers.count, slug: current_tag.slug}
    end
    home_tags_list
  end

end
