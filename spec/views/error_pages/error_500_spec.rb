require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "500 page" do
  it "should display the custom error page" do
    render :template => 'error_pages/error_500'
    response.should have_tag('h3','Some unexpected error has occured.')
    response.should have_tag('p', "We have been notified about this issue and we'll take a look at it shortly")
  end
end