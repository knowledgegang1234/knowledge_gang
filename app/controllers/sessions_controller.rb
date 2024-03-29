class SessionsController < Devise::SessionsController

  before_action :store_session, only: [:create]

  def new
    super
  end

  def create
    params = login_params
    user = User.find_for_authentication(email: params[:email])
    if user.valid_password?(params[:password]) && !user.confirmed?
      @alert = "Please confirm you email address. Resend confirmation mail <u><a href='/users/confirmation/new?email=#{user.email}' style='color: blue'>here</a></u>"
      respond_to do |format|
        format.js
      end
    else
      self.resource = warden.authenticate(auth_options)
      if resource && resource.active_for_authentication?
        sign_in(resource_name, resource)
        flash[:notice] = "Signed in successfully."
        respond_to do |format|
          format.js { redirect_to_url }
          format.html { redirect_to_url }
        end
      else
        @alert = "Invalid Email or Password." if [:not_found_in_database, :invalid].include?(warden.message)
        respond_to do |format|
          format.js
        end
      end
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password, :remember_me)
  end

  def store_session
    session[:return_to] = request.referer if [root_url, new_user_session_url, new_user_registration_url].exclude?(request.referer)
  end

  def redirect_to_url
    if session[:return_to].present?
      url = session[:return_to]
      session[:return_to] = nil
      redirect_to url and return
    else
      redirect_to root_path and return
    end
  end

end