class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end            
    u = User.new(:name => 'admin')
    u.password = 'admin'
    u.save
  end

  def self.down
    drop_table :users
  end
end
