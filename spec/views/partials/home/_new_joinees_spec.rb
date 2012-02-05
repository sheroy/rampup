require File.dirname(__FILE__) + '/../../../spec_helper'

describe "New Joinees" do
  before(:each) do
    employee = mock("New Joinee",:id=>1, :employee_id=>'12509',:common_name=>'name',:title=>'title',:location_id=>1,:date_of_joining => Time.parse('10/10/2009'))
    @new_joinees = [employee,employee,employee,employee]
    render :partial=>'partials/home/new_joinees', :locals=>{:new_joinees => @new_joinees}
    response.should be
  end
  it "should have the list of recently joined people" do
    response.should have_tag('table') do
      with_tag('tr:nth-child(2)') do
        @new_joinees.each do |new_joinee|
          with_tag('td:nth-child(1)',new_joinee.employee_id)
          with_tag('td:nth-child(2)',new_joinee.common_name)
          with_tag('td:nth-child(3)',new_joinee.title)
          with_tag('td:nth-child(4)',new_joinee.location_id)
          with_tag('td:nth-child(5)','10-Oct-2009')
        end
      end
    end
  end
  it "should display the header of recently joined people" do
    response.should have_tag('h3', 'Recently Joined Employees')
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('th:nth-child(1)','PSID')
        with_tag('th:nth-child(2)','Name')
        with_tag('th:nth-child(3)','Role')
        with_tag('th:nth-child(4)','Location')
        with_tag('th:nth-child(5)','Date Of Joining')
      end
    end
  end
end