require File.dirname(__FILE__) + '/../spec_helper'

describe ExperienceController do

  before(:each) do
    @profile=Profile.new
    @experience=Experience.new
    @experience.profile = @profile
    @controller.stub!(:check_authentication)
    @controller.instance_eval {flash.stub!(:sweep) }
  end

  describe "update" do

    it "should not update the experience of an employee when save fails" do
      #TODO : Render does not seem to work
      Experience.should_receive(:find_by_id).with("1").and_return(@experience)
      @experience.should_receive(:save).and_return(false)
      @controller.should_receive(:render).with(:action=>'edit', :id=>"1")
      get :update, :id=>1, :experience => {:technology=>"Java", :last_used=>Time.now}, :years=>"5", :months=>"2"

      flash[:error].should == "Errors while updating the experience"
    end

    it "should update the experience of an employee when proper qualification details are entered" do

      Experience.should_receive(:find_by_id).with("1").and_return(@experience)
      @experience.should_receive(:save).and_return(true)
      get :update, :id=>1, :experience => {:technology=>"Java", :last_used=>Time.now}, :years=>"5", :months=>"2"

      response.should redirect_to(:action=>'add', :profile_id=>@experience.profile_id)

    end
  end

  describe "edit" do
    it "should get the edit page for nth experience" do
      id='1'
      Experience.should_receive(:find_by_id).with(id).and_return(@experience)
      get :edit, :id=>id
      response.should be_success
    end
  end

  describe "delete" do
    it "should delete the correct experience" do
      Experience.should_receive(:find_by_id).with("1").and_return(@experience)
      @experience.should_receive(:destroy).and_return(true)
      get :delete, :id=>"1"
      flash[:notice].should == "Experience has been successfully deleted"
      response.should redirect_to(:action=>'add', :profile_id=>@experience.profile_id)
    end
  end

  describe "add" do

    it "should display the form" do
      Profile.should_receive(:find_by_id).and_return(@profile)
      get :add
      response.should be_success
    end

    it "should add the experience details to the correct profile" do
      @technology = Technology.new

      profile=ModelFactory.create_profile
      Technology.should_receive(:find_or_initialize_by_name).and_return(@technology)
      @technology.should_receive(:save).and_return(true)

      @controller.should_receive(:render).with(:action=>'add')

      post :add, :profile_id => profile.id, :experience => {:technology=>"Java", :last_used=>Time.now}, :years=>"5", :months=>"2"
      profile.reload
      profile.experiences.size.should == 1
      experience = profile.experiences.first
      experience.technology.should == "Java"
      experience.duration.should == 62
    end
  end
end
