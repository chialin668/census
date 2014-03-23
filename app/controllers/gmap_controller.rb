class GmapController < ApplicationController

  def initialize
    @app_name='GMAP'
    @title='Google Map'
    @tagline='iFanSee.com'
    @theme='aqualicious'

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([37.320644, -122.021325], 12)
  end

  def index
    
  end
  
  def gmarker
    @map.overlay_init GMarker.new([37.350408, -122.056942],:title => "Marker-1", :info_window => "Marker 1!")
    @map.record_init @map.add_overlay(GMarker.new([37.344858, -122.02655],:title => "Marker-2", :info_window => "Marker 2!"))
  end
  
  def custom
    @map.icon_global_init(GIcon.new(:image => "/images/icons/0-99/marker1.png", 
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :info_window_anchor => GPoint.new(9,2)), "icon1")    
    icon1 = Variable.new("icon1")
    @map.overlay_init GMarker.new([37.350408, -122.056942], :icon=>icon1, 
                                                      :title => "Marker-1", :info_window => "Marker 1!")

    @map.icon_global_init(GIcon.new(:image => "/images/icons/0-99/marker2.png", 
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :info_window_anchor => GPoint.new(9,2)), "icon2")    

    @map.record_init @map.add_overlay(GMarker.new([37.344858, -122.02655], :icon => Variable.new("icon2"), 
                                                        :title => "Marker-2", :info_window => "Marker 2!"))
  end
  
  #####################################  
  def rjs
    @map.overlay_init GMarker.new([37.350408, -122.056942],:title => "Marker-1", :info_window => "Marker 1!")
    @map.record_init @map.add_overlay(GMarker.new([37.344858, -122.02655],:title => "Marker-2", :info_window => "Marker 2!"))
  end

  def add_point
    @map = Variable.new("map") 
    @marker = GMarker.new([37.320644, -122.021325], :info_window => "some info here", :draggable => true)
  end  
  
  def clear
  end

  def rjs_custom
    @map.overlay_init GMarker.new([37.350408, -122.056942], 
                                        :image => "/images/icons/0-99/marker1.png", 
                                        :title => "Marker-1", :info_window => "Marker 1!")    

    
    @map.icon_global_init(GIcon.new(:image => "/images/icons/0-99/marker1.png", 
                                    :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :shadow => "/images/icons/google/shadow50.png",
                                      :shadow_size => GSize.new(37,34),
                                      :info_window_anchor => GPoint.new(9,2)), "icon1")    

  end
  
  def add_custom_point
    @map = Variable.new("map") 
    @marker = GMarker.new([37.320644, -122.021325], :info_window => "some info here", :draggable => true)
  end  
  
  
  #####################################  
  
  
  def gmarker_group
        marker1 = GMarker.new([37.350408, -122.056942],:info_window => "Hello from 1!")
        marker2 = GMarker.new([37.344858, -122.02655],:info_window =>"Hello from 2!")
        @map.overlay_global_init(GMarkerGroup.new(true,
                                        1 => marker1,
                                        2 => marker2),"myGroup")

  end

  
  def polyline
    polyline=GPolyline.new([[37.350408, -122.056942],[37.344858, -122.02655]],"#ff0000",3,1.0)
    @map.overlay_init(polyline)
  end

  
  def polygon
    polygon=GPolygon.new([[37.292875, -122.009581],[37.294584, -122.037276],[37.34013, -122.059498],[37.320644, -122.021325],
                          [37.292875, -122.009581]],
                          "#ff0000", 5, 0.5,
                            "#00ff00", 0.3)    
    @map.overlay_init(polygon)
  end
  
  def cluster
    markers = [GMarker.new([37.320644, -122.021325],:info_window => "1",:title => "HOYOYO"),
                  GMarker.new([37.32919, -121.989471],:info_window => "2",:description => "Chopoto" , :title => "Ay"),
                  GMarker.new([37.282875, -122.009581],:info_window => "3",:title => "Third"),
                  GMarker.new([37.323644, -122.032325],:info_window => "4",:title => "HOYOYO"),
                  GMarker.new([37.32419, -121.989371],:info_window => "5",:description => "Chopoto" , :title => "Ay"),
                  GMarker.new([37.285875, -122.004581],:info_window => "6",:title => "Third"),
                  GMarker.new([37.326644, -122.055325],:info_window => "7",:title => "HOYOYO"),
                  GMarker.new([37.32719, -121.989671],:info_window => "8",:description => "Chopoto" , :title => "Ay"),
                  GMarker.new([37.288875, -122.007581],:info_window => "9",:title => "Third"),    
                  GMarker.new([37.329644, -122.016325],:info_window => "10",:title => "HOYOYO"),
                  GMarker.new([37.32919, -121.989771],:info_window => "11",:description => "Chopoto" , :title => "Ay"),
                  GMarker.new([37.282875, -122.008581],:info_window => "12",:title => "Third"),
    ]
    clusterer = Clusterer.new(markers,:max_visible_markers => 1)  
   @map.overlay_init clusterer
  end

  ######################################################
  def manager 
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([59.91106, 10.72223],3)
    srand 1234
    markers1 = []
    1.upto(20) do  |i|
      markers1 << GMarker.new([59.91106 + 6 * rand - 3, 10.72223 + 6 * rand - 3],:title => "OY-20-#{i}", :info_window => "Group1!")
    end
    managed_markers1 = ManagedMarker.new(markers1,0,7)

    markers2 = []
    1.upto(200) do  |i|
      markers2 << GMarker.new([59.91106 + 6 * rand - 3, 10.72223 + 6 * rand - 3],:title => "OY-200-#{i}", :info_window => "Group2!")
    end
    managed_markers2 = ManagedMarker.new(markers2,8,9)

    markers3 = []
    1.upto(1000) do  |i|
      markers3 << GMarker.new([59.91106 +  6 * rand - 3, 10.72223 + 6 * rand - 3],:title => "OY-300-#{i}", :info_window => "Group3!")
    end
    managed_markers3= ManagedMarker.new(markers3,10)

    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers1,managed_markers2,managed_markers3])
    @map.declare_init(mm,"mgr")    
  end
  
  def geocoding
    results = Geocoding::get("2500 Faber Place, Palo Alto, CA")
        if results.status == Geocoding::GEO_SUCCESS
          puts results[0].latlon
          #  coord = results[0].latlon
          #  @map.overlay_init(GMarker.new(coord,:info_window => "Rue Clovis Paris"))
        end
  end
  
  ######################################################
  # Not working!!!
  def earthquake_rss
     result = Net::HTTP.get_response("earthquake.usgs.gov","/eqcenter/recenteqsww/catalogs/eqs7day-M5.xml")
     render :xml => result.body
  end

  def proxy
      result = Net::HTTP.get_response(URI.parse(@params[:q]))
      render :xml => result.body
  end

  def georss
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true)
    @map.center_zoom_init([38.134557,-95.537109], 3)
    @map.overlay_init(GeoRssOverlay.new(url_for(:action => "earthquake_rss")))
    
    @map.overlay_init(GeoRssOverlay.new("http://earthquake.usgs.gov/eqcenter/recenteqsww/catalogs/eqs7day-M5.xml",
                                :proxy => url_for(:action => "proxy")))
  end

  
end























