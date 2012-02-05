require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "500 page" do
  it "should display the custom error page" do
    render :template => 'error_pages/error_404'
    response.should have_tag('h3','404 - Page Not Found.')
    response.should have_tag('p', "The page you are looking for is not found.")
  end
end