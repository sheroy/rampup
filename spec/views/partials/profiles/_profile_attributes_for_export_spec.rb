require File.dirname(__FILE__) + '/../../../spec_helper'
describe "profile attributes for export" do
  it "should display the details of all the employees" do
    profiles=ModelFactory.create_profile
    render :partial=>'partials/profiles/profile_attributes_for_export', :locals => {:profiles => [profiles]}
    response.should be
    response.should have_tag('table') do
      with_tag('thead') do
        with_tag('tr') do
          with_tag('th','PSID')
          with_tag('th','Name')
          with_tag('th','Title')
          with_tag('th','Date of Joining')
        end
      end
      with_tag('tbody') do
        with_tag('tr') do
          with_tag('td:nth-child(1)','12345')
          with_tag('td:nth-child(2)','Mohan')
          with_tag('td:nth-child(3)','Application Developer')
          with_tag('td:nth-child(5)','6-Jun-2009')
        end
      end
    end
  end
end
