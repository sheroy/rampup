require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ApplicationController do

  it "should have check_authentication described in before filter" do
     ApplicationController.before_filters.should include(:authenticator)
  end

  describe "isLoggedIn"  do
    it "should return false if the user is nil"  do
      @controller.isLoggedIn.should == false
    end

    it "should return true if the use is logged in" do
      @controller.set_current_user(User.new(:username=>"admin", :password=>"pass"))
      @controller.isLoggedIn.should == true
    end

  end

  describe "currentUser" do
    it "should return the current_user if already set" do
      loggedInUser = User.new(:username=>"admin", :password=>"pass")
      @controller.set_current_user(loggedInUser)
      @controller.current_user.should be loggedInUser
    end

    it "should load the user by finding by user_name in the session" do
      loggedInUser = User.new(:username=>"admin", :password=>"pass")
      loggedInUser.save
      session[:cas_user] = "admin"

      @controller.current_user.should == loggedInUser
    end
  end
end
