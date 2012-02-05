require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "recent updates" do

  it "should display the recent updates" do

    profile1 = mock("profile1", :id => 1, :employee_id => 1, :name => "employee name 1", :common_name => "common name 1",
    :surname => "surname 1", :title => "title 1", :location_id => "location 1",
    :date_of_joining => Time.parse("05/21/1986"), :updated_at=>Time.parse("05/21/1986"), :completed=>true,:last_day=>nil)

    profile2 = mock("profile2", :id => 2, :employee_id => 2, :name => "employee name 2", :common_name => "common name 2",
    :surname => "surname 2", :title => "title 2", :location_id => "location 2",
    :date_of_joining => Time.parse("05/21/1986"), :updated_at=>Time.parse("05/21/1986"), :completed=>true,:last_day=>nil)
   
    profiles = [profile1,profile2]
   
    template.stub!(:will_paginate).and_return(true)
    assigns[:profiles]=profiles
    assigns[:title]="Title"
    render :template=>'profiles/profiles_list'
    response.should be_success

    response.should have_tag('h3',/Title/)

    profiles.each_with_index do |data, index|
      index = index + 1
      response.should have_tag('tr') do
        with_tag("td:nth-child(1) a[href=/profile/show/#{index}]", :text => index)
        with_tag("td:nth-child(2)", :text => "common name #{index}")
      end
      response.should have_tag('a', /1/)
    end  

  end
end