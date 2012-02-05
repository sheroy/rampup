require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TemplateEngine do
  before(:each) do
    @contents_of_file = ""
    @placeholder = ""
    @data = ""
    @expected = ""
  end

  it "should replace placeholder tags with data" do
    @contents_of_file = "The name is: RAMPUP_NAME"
    @placeholder = "RAMPUP_NAME"
    @data = "Wiggles"
    @expected = "The name is: Wiggles"
  end

  it "should replace date placeholders with correctly formatted date" do
    @contents_of_file = "The date of birth is: RAMPUP_DOB"
    @placeholder = "RAMPUP_DOB"
    @data = "1988-05-04"
    @expected = "The date of birth is: 04-05-1988"
  end

  it "should only replace placeholders that start with RAMPUP" do
    @contents_of_file = "The date of birth is: RAMP_DOB, RAMPUP_DOB"
    @placeholder = "RAMPUP_DOB"
    @data = "1988-05-04"
    @expected = "The date of birth is: RAMP_DOB, 04-05-1988"
  end

  it "should only replace the first instance of a placeholder" do
    @contents_of_file = "The date of birth is: RAMPUP_DOB, RAMPUP_DOB"
    @placeholder = "RAMPUP_DOB"
    @data = "1988-05-04"
    @expected = "The date of birth is: 04-05-1988, RAMPUP_DOB"
  end

  after(:each) do
    result = TemplateEngine.replace_first_occurrence_of_place_holder_with_data(@contents_of_file, @placeholder, @data)
    result.should == @expected
  end
end







