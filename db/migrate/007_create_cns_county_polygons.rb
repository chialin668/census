class CreateCnsCountyPolygons < ActiveRecord::Migration
  def self.up
    create_table :cns_county_polygons do |t|
    end
  end

  def self.down
    drop_table :cns_county_polygons
  end
end
