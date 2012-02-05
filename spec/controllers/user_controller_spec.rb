require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserController do

  describe "Login" do
    it "display already logged in if login page is requested after logging in" do

      @controller.set_current_user(User.new(:username=>"admin",:password=>'pass', :role=>'admin'))

      get :login

      response.should redirect_to(:controller=>'home',:action=>'index')
      flash[:notice].should == "Already Logged in"
    end

    it "should render the template if login page is requested" do

      get :login
      response.should be_success
      @controller.isLoggedIn.should == false

    end


  end

  describe "Logout" do

    it "should redirect to user login after logout is clicked" do

      get :logout

      response.should redirect_to(:controller=>'user',:action=>'login')
      session[:cas_user].should == nil
      @controller.current_user.should == nil

    end

  end

  describe "Sign In" do
    it "should authenticate a user and redirect to home page" do
      @user = mock("user",:id=>1, :username=>"rm", :role=>'rm')

      User.stub!(:authenticate).and_return(@user)
      get :signin

      response.should redirect_to employee_home_path
      session[:cas_user].should be

    end

    it "should flash login error when authentication fails" do

      @user = User.new
      User.should_receive(:authenticate).and_return(nil)
      get :signin

      response.should redirect_to(:controller=>'user',:action=>'login')
      flash[:login_error].should == "Username or Password Invalid"
      session[:cas_user].should_not be

    end

  end     


end