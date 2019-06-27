class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def json_user_not_authorized
    head 403
  end
end
