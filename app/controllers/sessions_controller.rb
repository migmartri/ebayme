# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  def new
  end

  def create
    logout_keeping_session!
    password_authentication(params[:login], params[:password])
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Te has deslogueado con éxito."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "No has podido loguearte como '#{params[:login]}'."
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
  def password_authentication(login, password)
    user = User.authenticate(login, password)
    if user == nil
      note_failed_signin
      @login       = login
      @remember_me = params[:remember_me]
      render :action => 'new'
    elsif user.enabled == false
      note_failed_signin
      @login       = login
      @remember_me = params[:remember_me]
    else
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
    end
  end
  
end
