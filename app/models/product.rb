class Product < ActiveRecord::Base  
  belongs_to :user  

  validates_presence_of :number, :max_bid, :message => 'no puede estar en blanco'
  validates_uniqueness_of :number, :scope => :user_id, :message => 'ya está en tu lista'
  validates_numericality_of :number, :max_bid, :message => 'no es un número'  
  
  def validate
    errors.add("max_bid", "La puja máxima es menor que el mínimo a pujar") if max_bid && max_bid < min_bid
    errors.add("finish_bid", "La puja ya está cerrada") if finish_bid <= Time.now
  end
  
  named_scope :unfinished, :conditions => ["finish_bid > ?", Time.now.utc.to_s(:db)], :order => 'finish_bid ASC'
  named_scope :finished, :conditions => ["finish_bid <= ?", Time.now.utc.to_s(:db)], :order => 'finish_bid ASC'
  
  def expire_in?(minutes)
    self.finish_bid < Time.now + minutes
  end
  
  def lost?
    self.min_bid >= self.max_bid
  end
  
  def setup(item, user)
    self.finish_bid = $tz.utc_to_local(item.listingDetails.endTime).to_s(:db)
    self.min_bid = item.sellingStatus.minimumToBid
    self.name = item.title
    self.url = item.listingDetails.viewItemURL.to_param
    self.user = user
  end
end

