class EbayWorker < BackgrounDRb::MetaWorker
  set_worker_name :ebay_worker
  
  def update_products
    updte, sms = 0, 0 # Variables "estadísticas"
    
    Product.find(:all, :conditions => ["finish_bid > ? OR sms = 0", Time.now]).each do |product|
      resp = find_product_in_ebay(product.number)

      # Si el precio del producto ha cambiado, lo actualizamos
      if product.min_bid.to_s != resp.item.sellingStatus.minimumToBid
        product.update_attribute(:min_bid, resp.item.sellingStatus.minimumToBid); updte = updte + 1
      end
 
      # Si no hemos avisado al usuario y el producto está a punto de expirar o el mínimo ha superado el máximo..
      if !product.sms && (product.expire_in?(TIME_MIN_TO_SMS) || product.lost?)
        if product.min_bid <= product.max_bid
          $gateway.send([product.user.movil], 
            "#{product.user.login}!! El producto: #{product.name}, esta por debajo del precio que disponias a pagar.")
        else
          $gateway.send([product.user.movil], 
            "#{product.user.login}, el producto: #{product.name}, esta por encima del precio que disponias a pagar.")          
        end
        product.update_attribute(:sms, true); sms = sms + 1                                                             
      end
    end  
    
    logger.info "Actualización realizada a las #{Time.now.to_s(:db)}. Se han actualizado #{updte} productos y mandado #{sms} mensajes."
  end
end

