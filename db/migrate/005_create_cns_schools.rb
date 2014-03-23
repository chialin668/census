class CreateCnsSchools < ActiveRecord::Migration
  def self.up
    create_table :cns_schools do |t|
    end
  end

  def self.down
    drop_table :cns_schools
  end
end
