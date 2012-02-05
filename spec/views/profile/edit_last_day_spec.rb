require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ProfileController do
it "should display date select option for an employee" do
  render :template =>'profile/edit_last_day'
  response.should be
  response.should have_tag('table')
    with_tag('tr:nth-child(1)') do
    with_tag('td:nth-child(1)', "Enter The Date Of Exit:")
  end
end
end