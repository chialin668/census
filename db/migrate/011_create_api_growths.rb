class CreateApiGrowths < ActiveRecord::Migration
  def self.up
    create_table :api_growths do |t|
    end
  end

  def self.down
    drop_table :api_growths
  end
end
