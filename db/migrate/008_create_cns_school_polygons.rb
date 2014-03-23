class CreateCnsSchoolPolygons < ActiveRecord::Migration
  def self.up
    create_table :cns_school_polygons do |t|
    end
  end

  def self.down
    drop_table :cns_school_polygons
  end
end
