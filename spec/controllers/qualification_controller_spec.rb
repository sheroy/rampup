require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QualificationController do

  before(:each) do
    @profile = Profile.new
    @controller.stub!(:check_authentication)
    @qualification = Qualification.new
    @controller.instance_eval {flash.stub!(:sweep) }
  end

  describe "edit" do

    it "should get the edit page for nth qualification" do
      id="1"
      Qualification.should_receive(:find_by_id).with(id).and_return(@qualification)
      get :edit, :id=>id
      response.should be_success
    end

  end

  describe "delete" do

    it "should delete the correct qualification" do
      Qualification.should_receive(:find_by_id).with("1").and_return(@qualification)
      @qualification.should_receive(:destroy).and_return(true)
      get :delete, :id=>"1"
      flash[:notice].should == "Qualification has been successfully deleted"
      response.should redirect_to(:action=>'add', :profile_id=>@qualification.profile_id)
    end

  end

  describe "add" do

    describe "get" do
      it "should get the Qualification form" do
        Profile.should_receive(:find_by_id).and_return(@profile)
        get :add
        response.should be_success
      end
    end

    describe "post" do
      before(:each) do
        @profile = ModelFactory.create_profile
        @branch = mock("Branch", :name=>'Branch')
        @college = mock("College", :name=>'College')
        @degree=mock("Degree", :name=>'Degree', :category=>'Category')
        @qualification = Qualification.new(:college=>"CIT", :branch=>"msc")

        Profile.should_receive(:find_by_id).and_return(@profile)
        Qualification.should_receive(:new).and_return(@qualification)
        Branch.should_receive(:find_or_initialize_by_name).and_return(@branch)
        College.should_receive(:find_or_initialize_by_name).and_return(@college)
        Degree.should_receive(:find_or_initialize_by_name).and_return(@degree)
      end

      it "should save qualification to right profile" do
        @degree.should_receive("category=")
        @qualification.should_receive(:valid?).and_return(true)

        @profile.qualifications.should_receive("<<").with(@qualification)
        post :add, :profile_id => @profile.id, :qualification => {:graduation_year => "2005", :branch=>"msc", :college=>"CIT", :degree=>"Msc", :category=>"PG-Engineering"}

        response.should be
        flash[:notice].should == "Qualification was successfully saved."

      end

      it "should not save when validations fail" do
        @degree.should_receive("category=")
        post :add, :profile_id => @profile.id, :qualification => {:graduation_year => "2005", :branch=>"", :college=>"", :degree=>'', :category=>''}
        response.should be
        flash[:error].should == "Please complete all 4 mandatory fields. Category, Degree, University, Year."
      end

      it "should retain all of the entered fields if 4 required fields are not provided" do
        @degree.should_receive("category=")
        post :add, :profile_id => @profile.id, :qualification => {:graduation_year => "2008", :branch=>"", :college=>"Berkeley", :degree=>'', :category=>''}
        response.should be
        flash[:error].should == "Please complete all 4 mandatory fields. Category, Degree, University, Year."
        params[:qualification][:college].should == 'Berkeley'
      end

    end


    it "should throw ActiveRecord NotFound error if profile is invalid" do
      lambda {
        post :add, :profile_id => 45, :qualification => {:graduation_year => "2005", :branch=>"msc", :college=>"CIT", :degree=>"Msc", :category=>"PG-Engineering"}
      }.should raise_error(ActiveRecord::RecordNotFound)

    end



  end

  describe "validate" do
    before(:each) do
      @profile = ModelFactory.create_profile
      Profile.should_receive(:find_by_id).and_return(@profile)
    end
    it "should redirect to add if there are not enough qualifications" do
      @profile.should_receive(:has_valid_qualifications?).and_return(false)
      get :validate, :profile_id => @profile.id
      flash[:error].should == "Please provide highest qualification details"
      response.should redirect_to(:action=>'add', :profile_id=>@profile.id)
    end

    it "should redirect to add experience page if there are enough qualifications" do
      @profile.should_receive(:has_valid_qualifications?).and_return(true)
      get :validate, :profile_id => @profile.id
      response.should redirect_to add_experience_path(:profile_id => @profile.id)
    end
  end

end
