require File.dirname(__FILE__) + '/../spec_helper'


describe Location do
  before(:each) do
    @location=Location.new
    @valid_attributes={
      :name => 'locale',
      :countries_id => 1
    }
  end

  it "should return all created location ids" do
    @location.attributes = @valid_attributes
    @location.save
    location2 = Location.new
    location2.name = "locale2"
    location2.countries_id = 2
    location2.save
    Location.get_all_location_ids.size.should==33
  end

  it "should return a sorted list all location names" do
    @location.attributes = @valid_attributes
    @location.save
    @location2 = Location.new
    @location2.name = "alocale"
    @location2.countries_id = 2
    @location2.save
    @locations = Location.getAllSortedLocations
    @locations.size.should == 33
    @locations.first.should == "Bangalore 1"
    @locations.last.should == "alocale"
  end

  it "should return name given id" do
    @location.attributes = @valid_attributes
    @location.save
    @location2 = Location.new
    @location2.name = "locale2"
    @location2.countries_id = 2
    @location2.save
    @location = Location.get_location_name_by_id(@location.id)
    @location.should == "locale"
  end

end
