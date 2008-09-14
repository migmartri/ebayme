class AddSmsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :sms, :boolean, :default => false
    
    Product.all.each do |product|
      product.update_attribute(:sms, false)
    end
  end

  def self.down
    remove_column :products, :sms
  end
end
