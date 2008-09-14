class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :user_id
      t.string :name
      t.string :number
      t.datetime :finish_bid
      t.float :min_bid, :max_bid

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
