require File.dirname(__FILE__) + '/../../spec_helper'

describe "Master Layout" do 
  before(:each) do
    template.should_receive(:render).with(:partial=>'partials/layout/top_panel')
    template.should_receive(:render).with(:partial=>'partials/layout/navigation_bar')
  end

  describe "when logged in as admin" do
    before(:each) do   
      session[:role]="admin"
      render :template=>'layouts/master'
      response.should be_success  
    end                    
    it "should redirect the user to admin dashboard when user clicks on the logo" do
      response.body.should have_tag('div#content') do
        with_tag('div#logo') do
          with_tag('div#logo-img') do
            with_tag('a[href=/admin]')
            with_tag('img[src=/assets/rampup-logo.jpg]')
          end
        end
      end
    end    
    it "should have the footer as thoughtworks and link to the thoughtworks.com home page" do
      response.body.should have_tag('div#footer') do
        with_tag('a[href="http://www.thoughtworks.com"]', "ThoughtWorks India")
      end
    end           
    it "should have the title rampup" do
      response.body.should have_tag('title','Ramp Up')    
    end
  end
end