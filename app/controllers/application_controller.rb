class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  # before_filter :verify_role_permissions
  
  def verify_role_permissions
#    consumer = []
#    publisher = ['materials/*', 'users/profile', 'home/desktop']
#    
#    
#    flash[:error] = "Access denied!"  
#    redirect_to root_url  

    redirect_to root_url unless current_user.has_role?(:admin)
  end
end
