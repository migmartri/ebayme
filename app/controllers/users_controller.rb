class UsersController < ApplicationController
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  

  # render new.rhtml
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes(params[:user])
      flash[:notice] = "Usuario actualizado."
      redirect_to :action => 'show', :id => current_user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "Usuario deshabilitado."
    else
      flash[:error] = "Hubo un problema deshabilitando al usuario #{@user.login}."
    end
    redirect_to :action => 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "Usuario habilitado."
    else
      flash.now[:error] = "Hubo un problema habilitando al usuario #{@user.login}."
    end
    redirect_to :action => 'index'
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.save if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      @user.register!
      self.current_user = @user
      redirect_to products_path
      flash[:notice] = "Bienvenido. Ya puedes comenzar a monotorizar las pujas eBay :)"
    else
      flash.now[:error]  = "No ha sido posible crear su cuenta. Por favor, intentenlo de nuevo o pongase en contacto con el administrador."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Registro completado! Logueate para continuar."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash.now[:error] = "Falta el codigo de activación. Pulsa el enlace que debes tener en tu correo electrónico."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "No encontramos usuario con ese código de activación. No estarás ya activado? Prueba a loguearte o contacta con el administrador."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_user
    @user = User.find(params[:id])
  end
end
