require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PictureController do

  before :each do
    @profile = Profile.new(:id=>1)
    @picture = Picture.new
    @profile_picture = ProfilePicture.new
  end

  it "should load upload_spreadsheet form for the picture" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    get :get, :id=>'1'
    response.should be
  end
  it "should create a new profile if the profile cannot be found" do
    Profile.should_receive(:new).and_return(@profile)
    @profile.should_receive(:save_without_validation).and_return(true)
    get :get
    response.should be
  end

  it "should upload_spreadsheet the picture" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    ProfilePicture.should_receive(:new).and_return(@profile_picture)
    @profile_picture.should_receive(:save).and_return(true)

    get :save, :id=>'1'
    response.should redirect_to(:controller=>'profile', :action=>'edit', :id=>@profile.id)
  end

  it "should not upload_spreadsheet the picture if the picture is not of the right format" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    ProfilePicture.should_receive(:new).and_return(@profile_picture)

    @profile_picture.should_receive(:save).and_return(false)
    @controller.should_receive(:render).with(:action=>:get)
    get :save, :id=>'1'
  end

  it "should show the picture" do
    Profile.should_receive(:find).with('1').and_return(@profile)
    get :show, :id=>'1'
    response.should be
  end

end