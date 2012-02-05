require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe "Immigration search" do

  before(:all) do
    ROLES =["Application Developer"] unless defined?(ROLES)
  end
  
  it "should have all the tags" do
    render :template=>'immigration/index'
    response.should be_success
    response.should have_tag('h3',"Immigration Information")
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('td:nth-child(1)',"Name")
        with_tag('td:nth-child(2)')
      end
       with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)',"Role")
        with_tag('td:nth-child(2)')
      end
      with_tag('tr:nth-child(3)') do
        with_tag('td:nth-child(1)',"Location")
        with_tag('td:nth-child(2)')
      end
      with_tag('tr:nth-child(4)') do
        with_tag('td:nth-child(1)',"Visa type")
        with_tag('td:nth-child(2)')
      end
    end
  end
end