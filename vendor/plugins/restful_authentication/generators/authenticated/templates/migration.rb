class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :enabled,                   :boolean,  :default => true
<% if options[:include_activation] -%>
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime<% end %>
<% if options[:stateful] -%>
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime<% end %>
    end
    add_index :<%= table_name %>, :login, :unique => true
    
    user = User.new
    user.login = "patrick.elder"
    user.email = "patrick.e.elder@gmail.com"
    user.password = "admin"
    user.password_confirmation = "admin"
    user.save(false)
    
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    
    Role.create(:name => "administrator")
    
    create_table :permissions do |t|
      t.integer :role_id, :user_id, :null => false
      t.timestamps
    end
    
    role = Role.find_by_name('administrator')
    user = User.find_by_login('patrick.elder')
    
    permission = Permission.new
    permission.role = role
    permission.user = user
    permission.save(false)
  end

  def self.down
    drop_table "<%= table_name %>"
    drop_table "roles"
    drop_table "permissions"
  end
end
