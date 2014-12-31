class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  add_flash_types :error1, :error2,:error3,:error4,:error5, :error6,:another_custom_type
end
