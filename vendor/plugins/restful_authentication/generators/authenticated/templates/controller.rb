# This controller handles the login/logout function of the site.  
class <%= controller_class_name %>Controller < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def new
  end

  def create
    logout_keeping_session!
    password_authentication(params[:login], params[:password])
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
  def password_authentication(login, password)
    <%= file_name %> = <%= class_name %>.authenticate(login, password)
    if <%= file_name %> == nil
      note_failed_signin
      @login       = login
      @remember_me = params[:remember_me]
      render :action => 'new'
    elsif <%= file_name %>.enabled == false
      note_failed_signin
      @login       = login
      @remember_me = params[:remember_me]
    else
      self.current_<%= file_name %> = <%= file_name %>
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
    end
  end
  
end
