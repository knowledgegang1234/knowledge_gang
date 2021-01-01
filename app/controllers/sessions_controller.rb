class SessionsController < Devise::SessionsController

  before_action :store_session, only: [:create]

  def new
    super
  end

  def create
    self.resource = warden.authenticate(auth_options)
    if resource && resource.active_for_authentication?
      sign_in(resource_name, resource)
      flash[:notice] = "Signed in successfully."
      if session[:return_to].present?
        url = session[:return_to]
        session[:return_to] = nil
        respond_with resource, location: url
      else
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    else
      @alert = "Invalid Email or Password." if warden.message == :not_found_in_database
      respond_to do |format|
        format.js
      end
    end
  end

  def store_session
    session[:return_to] = request.referer if [root_url, new_user_session_url, new_user_registration_url].exclude?(request.referer)
  end

end