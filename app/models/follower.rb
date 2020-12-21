class Follower < ApplicationRecord

  default_scope { where(deleted_at: nil) }

  belongs_to :followable, polymorphic: true

  def destroy
    update_column(:deleted_at, Time.now)
  end

end
