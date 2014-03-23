class TruController < ApplicationController
  
  @gmap_key="ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA"

  def initialize
    @app_name='TRU'
    @title='Trulia'
    @tagline='iFanSee.com'
    @theme='aqualicious'
  end

  def state
    
    state=CnsState.find_by_state_code('CA')
    polygon=CnsStatePolygon.find_all_by_polygon_id(state.polygon_id)
    
    polylines=[]
    for point in polygon
      #puts "#{point.geotype}: #{point.lng.to_f} - #{point.lat.to_f}" if point.geotype=='C'
      #puts "#{point.geotype}: #{point.lng.to_f} - #{point.lat.to_f}" if point.geotype=='P'

      if point.geotype=='C'
        map_center= "map.setCenter(new GLatLng(#{point.lat.to_f}, #{point.lng.to_f}), 5);\n" 
      elsif point.geotype=='P'
        polylines << "new GLatLng(#{point.lat.to_f}, #{point.lng.to_f})\n"
      end
    end
    
    @jscript=%Q(
      <script type="text/javascript">
      function initialize() {
        if (GBrowserIsCompatible()) {
          var map = new GMap2(document.getElementById("map_canvas"));
            #{map_center}
          var polyline = new GPolyline([
            #{polylines.join(', ')}
          ], "#ff0000", 5);
          map.addOverlay(polyline);
        }
      }  
      </script>
    ) 
    
  end
  
  def county

    @html_type = params[:html_type]
  
    county=CnsCounty.find_by_county_name('Santa Clara')    
    polygon=CnsCountyPolygon.find_all_by_polygon_id(county.polygon_id)
    
    polylines=[]
    for point in polygon
      #puts "#{point.geotype}: #{point.lng.to_f} - #{point.lat.to_f}" if point.geotype=='C'
      #puts "#{point.geotype}: #{point.lng.to_f} - #{point.lat.to_f}" if point.geotype=='P'

      if point.geotype=='C'
        map_center= "map.setCenter(new GLatLng(#{point.lat.to_f}, #{point.lng.to_f}), 9);\n" 
      elsif point.geotype=='P'
        polylines << "new GLatLng(#{point.lat.to_f}, #{point.lng.to_f})\n"
      end
    end
    
    @jscript=%Q(
      <script type="text/javascript">
      function initialize() {
        if (GBrowserIsCompatible()) {
          var map = new GMap2(document.getElementById("map_canvas"));
            #{map_center}
          var polyline = new GPolyline([
            #{polylines.join(', ')}
          ], "#ff0000", 5);
          map.addOverlay(polyline);
        }
      }  
      </script>
    )

  end
  
  def zipcode
    zip=CnsZipcode.find_by_zipcode('95129')
    puts zip.polygon_id
    
    polygon=CnsZipPolygon.find_all_by_polygon_id(zip.polygon_id)
    
    polylines=[]
    for point in polygon
      #puts "#{point.geotype}: #{point.lng.to_f} - #{point.lat.to_f}" if point.geotype=='C'
      #puts "#{point.geotype}: #{point.lng.to_f} - #{point.lat.to_f}" if point.geotype=='P'

      if point.geotype=='C'
        map_center= "map.setCenter(new GLatLng(#{point.lat.to_f}, #{point.lng.to_f}), 13);\n" 
      elsif point.geotype=='P'
        polylines << "new GLatLng(#{point.lat.to_f}, #{point.lng.to_f})\n"
      end
    end
    
    @jscript=%Q(
      <script type="text/javascript">
      function initialize() {
        if (GBrowserIsCompatible()) {
          var map = new GMap2(document.getElementById("map_canvas"));
            #{map_center}
          var polyline = new GPolyline([
            #{polylines.join(', ')}
          ], "#ff0000", 5);
          map.addOverlay(polyline);
        }
      }  
      </script>
    )
  end
  
end
