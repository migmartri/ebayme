class AddMovilToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :movil, :string
  end

  def self.down
    remove_column :users, :movil
  end
end
