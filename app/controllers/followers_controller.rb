class FollowersController < ApplicationController

  def follow_update
    followable_type = params[:followable_type]
    follow_action = params[:follow_action]
    is_list_page_req = params[:list_page]
    resource = followable_type.constantize.find_by(id: params[:followable_id])
    @follower = Follower.unscoped.find_or_initialize_by(
      user_id: current_user.id, followable_id: resource.id, followable_type: followable_type
    )
    @followable_type = resource.class.name
    @followable_id = resource.id
    if follow_action == 'follow'
      @follower.deleted_at = nil
      @follower.save
      @follow_action = 'unfollow'
    elsif follow_action == 'unfollow'
      @follower.destroy
      @follow_action = 'follow'
    end
    # For update on list page
    @is_list_page = is_list_page_req ? true : false
    @followable_type_role = is_list_page_req ? Follower.get_entity_type_role(resource) : nil
    respond_to do |format|
      format.js
    end
  end

end