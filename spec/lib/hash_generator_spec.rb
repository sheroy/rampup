require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe HashGenerator do
  it "should return a hash key joind by underscore" do
    @profile1=mock("chennai resource-application developer",:location_id=>'CHENNAI',:type=>"Support",:title=>'Application Developer')
    HashGenerator.generate_key(@profile1, "location_id", "title").should == "CHENNAI_Application Developer"
  end

  it "should return a hash when an array is given" do
    @profile = Profile.new(:employee_id=>"12345",:title => "hello", :location_id => "2")
    @profile.save(:validate => false)
    @profile = Profile.role_and_location_wise_breakdown
    hash =  HashGenerator.convert_to_hash(@profile,"location_id", "title")
    hash["2_hello"].should == "1"
  end
end

