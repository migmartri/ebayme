class ProductsController < ApplicationController
  before_filter :login_required
  
  def index
    @products = current_user.products.unfinished
  end
  
  def finished
    @products = current_user.products.finished
  end
  
  def new    
    @product = Product.new    
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def create
    params[:product][:number] = params[:product][:number].strip # Quitar espacios es clave para encontrar el producto :P
    @product = Product.new(params[:product])  
    
    # Setup del producto
    begin
      @product.setup(find_product_in_ebay(params[:product][:number]).item, current_user)
    rescue
      @product.errors.add(:number, "Producto no encontrado")
      flash.now[:error] = "Existen errores."
      render :action => 'new'
      return
    end   
    
    if @product.save
      flash[:notice] = "Producto añadido"
      redirect_to root_path
    else
      flash.now[:error] = "El producto no ha sido añadido"
      render :action => 'new'
    end
  end
  
  def update
    @product = Product.find(params[:id])
    
    if @product.update_attributes(params[:product])
      # Ante un cambio de precio el sms debería mandarse de nuevo..
      @product.update_attribute(:sms, false) if @product.sms
      flash[:notice] = "Producto actualizado"
      redirect_to root_path
    else
      flash.now[:error] = "El producto no ha sido actualizado"
      render :action => 'edit'
    end
  end
  
  def update_products
    if !(@products = current_user.products.unfinished).blank?
      render :partial => 'product', :collection => @products
    else
      render :text => "-- No existe ningún producto activo --"
    end                                                           
  end  
  
protected
  def find_product_in_ebay(number)
    $eBay.GetItem(:DetailLevel => 'ItemReturnAttributes', :ItemID => number, :IncludeWatchCount => 'true')
  end
end  