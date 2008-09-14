# Documentado en http://juan.gg/blog/2008/04/12/rails-paginas-estaticas/

class PagesController < ApplicationController
  verify :params => :name, :only => :show, :redirect_to => :root_path
  before_filter :ensure_valid, :only => :show

  def show
    render :template => "pages/#{current_page}"
  end

  protected

  def current_page
    params[:name].to_s.downcase
  end

  def ensure_valid
    unless template_exists? "pages/#{current_page}"
      redirect_to root_path
    end
  end
end
