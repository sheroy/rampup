require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Letterhead do
  before(:each) do
    @letterhead=Letterhead.new
    @valid_attributes={
      :office_name => 'Gurgaon',
      :template_path => '#{Rails.root}/tmp/letterhead_sample.pdf'
    }
  end

  it "should be valid with valid attributes" do
    @letterhead.attributes = @valid_attributes
    @letterhead.should be
  end

  it "should be invalid without office name" do
    @valid_attributes.delete(:office_name)
    @letterhead.attributes = @valid_attributes
    @letterhead.should_not be_valid
  end

  it "should be invalid without template" do
    @valid_attributes.delete(:template_path)
    @letterhead.attributes = @valid_attributes
    @letterhead.should_not be_valid
  end

  it "should be invalid if the office name is not unique" do
    @letterhead.attributes=@valid_attributes
    @letterhead.save
    @new_letterhead=Letterhead.new
    @new_letterhead.office_name='Gurgaon'
    @new_letterhead.template_path='some_path'
    @new_letterhead.should_not be_valid
    @new_letterhead.errors_on(:office_name).should==["has already been taken"]
  end

end
