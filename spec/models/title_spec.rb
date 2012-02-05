require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Title do
  before(:each) do
    @title = Title.new(:name=>"Mr")
    @title.save()
  end

  it "should return all titles sorted" do
    Title.getAllSortedTitles.should == ["Account Manager", "Administration Specialist", "Developer", "Graduate", "Infrastructure Specialist", "Mr"]
  end

end
