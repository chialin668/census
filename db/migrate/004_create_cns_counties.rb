class CreateCnsCounties < ActiveRecord::Migration
  def self.up
    create_table :cns_counties do |t|
    end
  end

  def self.down
    drop_table :cns_counties
  end
end
