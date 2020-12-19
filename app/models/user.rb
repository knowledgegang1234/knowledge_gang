class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  belongs_to :country, optional: true
  has_many :blogs
  has_many :likes
  has_many :bookmarks
  has_many :followers, as: :followable
  has_many :taggings
  has_many :tags, through: :taggings
  after_save :set_username

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

  def tags
    super.group(:name).count
  end

  def top_tags
    self.tags.sort_by{ |_, value| value }.reverse.first(5).to_h
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
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.avatar = auth.info.image
      end
    end
  end

end
