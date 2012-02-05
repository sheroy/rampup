require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do 
   @user = User.new    
  end

 it "should be invalid without a username" do
   @user.should_not be_valid
   @user.errors[:username].should == ["cant be blank"]
   @user.username = "user"
   @user.should be_valid
 end        
 
 describe "is a valid password?" do
   it "should return false if the password is not valid" do
     User.is_valid_password?("12").should==false
   end
   it "should return true if password is true" do
     User.is_valid_password?("1234567").should == true
   end
 end

 
 
 it "should authenticate user if password is valid" do
   user = User.new
   user.username='user'
   user.password='user'
   user.role='role'
   user.save
   User.authenticate("user", "user").should == user
 end
 
end
