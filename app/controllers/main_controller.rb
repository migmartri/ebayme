class MainController < ApplicationController
  before_filter :login_required, :except => [:index]
  
  def index
    redirect_to products_path if logged_in?
  end
end          