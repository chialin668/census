class CreateMyZipcodes < ActiveRecord::Migration
  def self.up
    create_table :my_zipcodes do |t|
    end
  end

  def self.down
    drop_table :my_zipcodes
  end
end
