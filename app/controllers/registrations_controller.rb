class RegistrationsController < Devise::RegistrationsController

  before_action :store_session, only: [:create]

  respond_to :html, :js

  def new
    super
  end

  def create
    @user = User.create(user_params)
    unless @user.errors.full_messages.present?
      sign_in(:user, @user)
      flash[:notice] = "Registered successfully."
      if session[:return_to].present?
        url = session[:return_to]
        session[:return_to] = nil
        redirect_to url and return
      else
        redirect_to root_path and return
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember)
  end

  def store_session
    session[:return_to] = request.referer if [root_url, new_user_session_url, new_user_registration_url].exclude?(request.referer)
  end

end