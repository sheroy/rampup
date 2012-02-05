class Location < ActiveRecord::Base
   validates_presence_of :name
  def self.get_location_name_by_id(location_id)
    location = self.find_by_id(location_id)
    location ? location.name : ""
  end

  def self.get_all_location_ids()
    return self.all.collect {|location1|location1.id}
  end


  def self.getAllSortedLocations
    return Location.all.collect {|location| location.name}
  end

end