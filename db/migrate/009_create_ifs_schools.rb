class CreateIfsSchools < ActiveRecord::Migration
  def self.up
    create_table :ifs_schools do |t|
    end
  end

  def self.down
    drop_table :ifs_schools
  end
end
