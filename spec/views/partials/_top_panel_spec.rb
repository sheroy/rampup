require File.dirname(__FILE__) + '/../../spec_helper'

describe "Top Panel" do               

  it "should not display anything when user is not logged in" do
    render :partial=>'partials/layout/top_panel'
    response.should be_success
    response.should have_text("")
  end
end