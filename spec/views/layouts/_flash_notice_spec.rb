require File.dirname(__FILE__) + '/../../spec_helper'

describe "Flash Notice" do
  it "should display the notice when it is present" do
    flash[:notice] = "notice"
    render :partial=>'partials/layout/flash_notice'
    response.should be_success
    
    response.should have_tag("div.info",'notice')
  end
  
  it "should display the erros when it is present" do
    flash[:error] = "errors"
    render :partial => 'partials/layout/flash_notice'
    response.should have_tag("div.errors","errors")
  end
  
  it "should not have the info div if the notice is not present" do
    render :partial => 'partials/layout/flash_notice'
    response.should_not have_tag('div.info')
  end
  
  it "should not have the errros div if the errors is not present" do
    render :partial => 'partials/layout/flash_notice'
    response.should_not have_tag("div.errors")
  end
  
end