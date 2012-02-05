require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Profile Attributes" do
  it "should be rendered" do
    profile1 = mock("profile1", :id => '1', :employee_id => 1, :name => "employee name 1", :common_name => "common name 1",
    :surname => "surname 1", :title => "title 1", :location_id => 1,
    :date_of_joining => Time.parse("1986-05-21"), :completed=>true,:last_day=>nil)

    profile2 = mock("profile2", :id => '2', :employee_id => 2, :name => "employee name 2", :common_name => "common name 2",
    :surname => "surname 2", :title => "title 2", :location_id => "location 2",
    :date_of_joining => Time.parse("2009-01-01"), :completed=>true,:last_day=>nil)

    render :partial => "partials/profiles/profile_attributes", :locals =>{:profiles=>[profile1, profile2]}

    profile = [profile1 , profile2]

    response.should be_success

    with_tag("a[href=/profile/show/1]")
    with_tag("td", :text => "common name 1")
    with_tag("td", :text => "title 1")
    with_tag("td", :text => "1")
    with_tag("td a[href=/profile/edit/1]")
  end
  it "should not have edit and mark as complete tags for exit employees" do
     profile1 = mock("profile1", :id => '1', :employee_id => 1, :name => "employee name 1", :common_name => "common name 1",
    :surname => "surname 1", :title => "title 1", :location_id => 1,
    :date_of_joining => Time.parse("1986-05-21"), :completed=>true,:last_day=>Time.now.to_date)
    render :partial => "partials/profiles/profile_attributes", :locals =>{:profiles=>[profile1]}
    response.should be_success
    response.should_not have_tag('td','Edit')
    response.should_not have_tag('td','Mark as Complete')
  end
end