require File.dirname(__FILE__) + '/../../spec_helper' 

describe "Search panel" do
  describe "when logged in as rm" do
    it "should display the rm search boxes" do     
      #TODO : For forms 
      session[:role]="rm"
      session[:user]="rm"
      render :partial=>'partials/layout/search_panel'
      
      response.should be_success
    end
  end
  describe "when logged in as admin" do
    it "should display the admin search boxes" do    
      # TODO : Check for partials
      session[:role]="admin"
      session[:user]="admin"
      render :partial => 'partials/layout/search_panel'
      response.should be_success
    end
  end
end