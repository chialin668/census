class CreateCnsZipPolygons < ActiveRecord::Migration
  def self.up
    create_table :cns_zip_polygons do |t|
    end
  end

  def self.down
    drop_table :cns_zip_polygons
  end
end
