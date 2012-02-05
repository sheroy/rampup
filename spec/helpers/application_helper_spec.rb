require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
  it "bug fix: application Helper should handle nil values" do
    custom_date_with_month_and_year(nil).should=="Not-Set"
  end
  it "should get the month in words" do
    month=6
    month_name(month).should=='Jun'
  end
  it "should check if an object is nil and send not set if its nil" do
    display_if_not_nil(nil).should == '--Not-Set--'
  end
  it "should return the same object if the object is already set " do
    display_if_not_nil("nil").should == "nil"
  end
  it "should get the date with just the month and year" do
    date = Time.parse('10/10/2009')
    custom_date_with_month_and_year(date).should == "Oct-2009"
  end
  it "should get the date in proper format" do
    date = Time.parse('20/10/2009')
    custom_date_with_month(date).should =='20-Oct-2009'
  end
  it "should display the months in years and months" do
    display_months_in_years(120).should == "10 yr 0 mth"
  end
  it "should convert experience in months to years" do
    profile=Profile.new(:years_of_experience=>30)
    profile.save(:validate => false)
    convert_years_of_experience_to_years(profile.id).should==2
  end
  it "should convert experience in months to years and months" do
    profile=Profile.new(:years_of_experience=>30)
    profile.save(:validate => false)
    convert_years_of_experience_to_months(profile.id).should==6
  end
  describe "experience duration" do
    before(:each) do
      profile=Profile.new(:employee_id=>'11111')
      profile.save(:validate => false)
      @experience=Experience.new(:technology=>'tech',:duration=>20)
      profile.experiences<<@experience
    end
    it "should convert experience duration to years" do
      convert_duration_to_years(@experience.id).should==1
    end
    it "should convert experience duration to years and months" do
      convert_duration_to_months(@experience.id).should==8
    end
  end
end