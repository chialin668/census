#
# Install: ruby script/plugin install svn://rubyforge.org/var/svn/ym4r/Plugins/GM/trunk/ym4r_gm
# Doc: http://ym4r.rubyforge.org/ym4r_gm-doc/
#
class SchoolController < ApplicationController

  def initialize
    @app_name='SCHOOL'
    @title='School'
    @tagline='iFanSee.com'
    @theme='aqualicious'
  end

  def index
    
  end

  def district
    district_gmarker
  end

  def district_gmarker
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)

    #
    # District
    #
    points=[]
    district=CnsSchool.find_by_state_code_and_district_type_and_district_name('CA', 'E', 'Cupertino Union Elementary')    
    polygon=CnsSchoolPolygon.find_all_by_polygon_id_and_district_type(district.polygon_id, district.district_type)
    for point in polygon
      @map.center_zoom_init([point.lat.to_f, point.lng.to_f], 13) if point.geotype=='C'
      points << [point.lat.to_f, point.lng.to_f] if point.geotype=='P'
    end
    polygon=GPolygon.new(points, "#ff0000", 3, 0.5, "#00ff00", 0.1)
    @map.overlay_init(polygon)

    # 
    # School
    #
    markers=[]
    schools=IfsSchool.find_all_by_district_name_and_stype_and_status('Cupertino Union', 'E', 'OPEN')
    for school in schools
      next if school.lng=='null' or school.lat=='null' or school.school_name == ''
      # puts "#{school.id}: #{school.school_name}: #{school.lng}, #{school.lat}"  
      markers << GMarker.new([school.lat, school.lng], :info_window=>school.school_name ,:title =>school.school_name) 
      school_name="<b>#{school.school_name}</b><br />"
      address="#{school.address}<br /> #{school.city}<br /> #{school.state} #{school.zip}<br />"
      url="<a href='http://www.google.com>google</a>"
      @map.overlay_init(GMarker.new([school.lat, school.lng],
                                      :title => school.school_name, 
                                      :info_window => "#{school_name} #{address} #{url}"))
    end
  end
  


  def district_cluster
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)

    #
    # District
    #
    points=[]
    district=CnsSchool.find_by_state_code_and_district_type_and_district_name('CA', 'E', 'Cupertino Union Elementary')    
    polygon=CnsSchoolPolygon.find_all_by_polygon_id(district.polygon_id)
    for point in polygon
      @map.center_zoom_init([point.lat.to_f, point.lng.to_f], 13) if point.geotype=='C'
      points << [point.lat.to_f, point.lng.to_f] if point.geotype=='P'
    end
    polygon=GPolygon.new(points, "#ff0000", 3, 0.5, "#00ff00", 0.1)
    @map.overlay_init(polygon)

    # 
    # School
    #
    markers=[]
#    schools=IfsSchool.find_all_by_district_name_and_stype_and_status('Cupertino Union', 'E', 'OPEN')
    schools=IfsSchool.find_all_by_district_name('Cupertino Union')
    for school in schools
      next if school.lng=='null' or school.lat=='null' or school.school_name == ''
      # puts "#{school.id}: #{school.school_name}: #{school.lng}, #{school.lat}"  
      markers << GMarker.new([school.lat, school.lng], :info_window=>school.school_name ,:title =>school.school_name) 
    end

    clusterer = Clusterer.new(markers, :max_visible_markers=>1)  
    @map.overlay_init clusterer
  
  end

end
