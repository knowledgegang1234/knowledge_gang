class Follower < ApplicationRecord

  default_scope { where(deleted_at: nil) }

  belongs_to :followable, polymorphic: true

  def destroy
    update_column(:deleted_at, Time.now)
  end

  def self.get_entity_type_role(entity)
    case entity
    when Category
      0
    when User
      1
    when Tag
      2
    end
  end

end
