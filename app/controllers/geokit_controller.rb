class GeokitController < ApplicationController
  include GeoKit
  include GeoKit::Geocoders 
  
  def index
#    res=GeoKit::Geocoders::GoogleGeocoder.geocode('2500 Faber Place, Palo Alto, CA') 
#    puts res.to_s 
    
    schools=IfsSchool.find(:all, :origin => [38.657228, -121.006547], :order => "distance asc")
    
    0.upto(10) do |i|
      puts "#{schools[i].school}: #{schools[i].distance}"
    end
    
  end

  def geocode
    loc = GeoKit::Geocoders::GoogleGeocoder.geocode('1 Pennsylvania Ave, Washington, DC 20500')    
    puts loc.to_s
    puts ''
  end  

  def memory    
    first_loc=LatLng.new(37.775,-122.418)
    second_loc=LatLng.new(32.813,-96.948)
    puts "Distance between: #{first_loc.distance_to(second_loc)}"

    sf=GoogleGeocoder.geocode('San Francisco,CA') 
    irving=GoogleGeocoder.geocode('Irving,TX') 
    puts "SF: #{sf.ll}"
    puts "Irving: #{irving.ll}"
    puts "Miles: #{sf.distance_to(irving)}"
    puts "KMs: #{sf.distance_to(irving, :units=>:kilometers)}"
    puts "Flat: #{sf.distance_to(irving, :formula=>:flat)}"
    puts "\n\n"
  end

  def address
    schools=IfsSchool.find(:all, :limit=>30)
    for school in schools
      address = "#{school.address}, #{school.city}, #{school.state} #{school.zip}"
      loc=GoogleGeocoder.geocode(address)
#    puts "#{loc.full_address}, #{loc.ll}"
    end    
  end
 
  def distance

    sf=GoogleGeocoder.geocode('San Francisco, CA 94117, USA') 
    
    distances=[]
    schools=IfsSchool.find(:all, :limit=>30)
    for school in schools 
      loc=LatLng.new(school.lng, school.lat)
      puts "#{sf.distance_to(loc).to_f} miles: #{school.school} "
    end
    
  end

  def zip1
    loc=GoogleGeocoder.geocode('95129')
    puts "#{loc.full_address}, #{loc.ll}"
    polygons=MyZipcode.find :all, :origin=>loc, 
                              :conditions=>"geotype='C' and distance between 10 and 15",
                              :order=>'distance'
    polygons.each do |polygon| 
      zip=CnsZipcode.find_by_polygon_id(polygon.polygon_id) 
      puts "#{zip.zipcode}: #{polygon.distance} - (#{polygon.lng}, #{polygon.lat})" 
    end
  end

  def db
    loc=GoogleGeocoder.geocode('95129')
    puts "#{loc.full_address}, #{loc.ll}"
    schools=IfsSchool.find :all, :origin=>loc, 
                                :conditions=>"stype='E' and status='OPEN' and distance<5", 
                                :order=>'distance asc'
    schools.each do |school| 
      puts "#{school.distance} miles: (#{school.lng}, #{school.lat}) #{school.cds}: #{school.school}, #{school.address}, #{school.city}"   
    end
    puts "========================================================"

  end
 
end
























 
