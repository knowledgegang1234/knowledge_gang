class User < ApplicationRecord

  include Searchable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  belongs_to :country, optional: true
  has_many :blogs
  has_many :likes
  has_many :comments
  has_many :bookmarks
  has_many :bookmarked_blogs, through: :bookmarks, source: :blog
  has_many :followers, as: :followable
  has_many :taggings
  has_many :tags, through: :taggings

  validates :username, :email, uniqueness: true, allow_nil: true

  after_create :set_username

  before_save :reindex_blogs, if: proc {|user| user.name_changed? || user.username_changed?}

  enum status: { active: 1, pending: 2 }

  mount_uploader :avatar, ImageUploader

  def as_indexed_json(options = {})
    self.as_json(
      only: [:username, :name, :blogs_count]
    )
  end

  def following_users
    Follower.where(user_id: id, followable_type: 'User')
  end

  def following_tags
    Follower.where(user_id: id, followable_type: 'Tag')
  end

  def following_categories
    Follower.where(user_id: id, followable_type: 'Category')
  end

  def liked_blog?(blog)
    likes.where(blog: blog).exists?
  end

  def bookmarked?(blog)
    bookmarks.where(blog: blog, active: true).exists?
  end

  def following?(resource)
    send("following_#{resource.class.table_name}").where(followable_id: resource.id).exists?
  end

  def admin?
    false #self.is_admin
  end

  def set_username
    user_name = ''
    loop do
      user_name = (email.split("@").first.gsub(".","") + rand(999).to_s)
      break user_name unless User.where(username: user_name).exists?
    end
    self.update_column(:username, user_name)
  end

  def top_tags
    self.tags.select('tags.id,tags.name,tags.slug,count(taggings.tag_id) as count').group('tags.id,taggings.tag_id,tags.name,tags.slug').to_a.sort_by(&:count).reverse
  end

  def people_suggestion_on_category(already_following_users)
    categories_follow = self.following_categories
    users_suggestions = {}
    if categories_follow.count > 1
      # N+1 Query is here Danger !!!
      categories_follow.each do |category_follow|
        curr_category = category_follow.followable
        users_suggestions["#{curr_category.name}"] = User.joins(:blogs).where(blogs: {category_id: curr_category.id}).distinct - already_following_users
      end
    elsif categories_follow.count == 1
      curr_category = categories_follow.first.followable
      users_suggestions["#{curr_category.name}"] = User.joins(:blogs).where(blogs: {category_id: curr_category.id}).distinct - already_following_users
    else
      curr_category = Category.first
      users_suggestions["#{curr_category.name}"] = User.joins(:blogs).where(blogs: {category_id: curr_category.id}).distinct - already_following_users
    end
    users_suggestions.reject!{|k,v| v.count == 0}
  end

  def reindex_blogs
    blogs.each do |blog|
      blog.es_reindex
    end
  end

  class << self
    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
        if data = session["devise.google_oauth2"] && session["devise.google_oauth2_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def from_omniauth(auth)
      user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      # user.avatar = auth.provider == 'facebook' ? auth.info.image + '&type=normal' : auth.info.image
      user.status = User.statuses[:active] if user.pending?
      user.skip_confirmation! if user.new_record?
      user.save!
      user
    end
  end

end
