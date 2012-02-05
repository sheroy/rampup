require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchController do

  before(:each) do
    @controller.stub!(:check_authentication)
    @search_query = {"name"=>"arvin", "title"=>"", "location_id"=>""}
    @paginated_profiles = mock("profiles", :total_pages => 1, :length => 1, :each_with_index => @profiles)
  end
  
  describe "role_distribution_list" do
    it "should display the profiles" do
        Profile.should_receive(:paginate)
        @controller.should_receive(:render).with(:template=>'profiles/role_distribution_results')
        get :role_distribution_list,:location_id=>'1',:role=>'Application Developer'
        response.should be
    end
    it "should export the search results to excel" do
       Profile.should_receive(:all)
       @controller.should_receive(:render).with(:partial=>'partials/profiles/profile_attributes_for_export', :locals => {:profiles => @profiles},:layout=>false)
       get :export_role_results,:location_id=>'1',:role=>'Application Developer'
       response.should be
    end
  end

  describe "qualification_list" do
    it "should display the profiles" do
      profile=ModelFactory.create_profile
      qualification=ModelFactory.create_qualification(:category=>'UG-Engg')
      profile.qualifications<<qualification
       @controller.should_receive(:render).with(:template=>'profiles/results')
      get :qualification_distribution_list,:category=>'UG-Engg',:location_id=>'1'
      response.should be
    end
    it "should export the search results" do
      Profile.should_receive(:all)
       @controller.should_receive(:render).with(:partial=>'partials/profiles/profile_attributes_for_export', :locals => {:profiles => @profiles},:layout=>false)
       get :export_qualification_results,:category=>'UG-Engg',:location_id=>'1'
       response.should be
    end
  end

  describe "head_count_list" do
    it "should display the profiles" do
      Profile.should_receive(:paginate)
      @controller.should_receive(:render).with(:template=>'profiles/head_count_results')
      get :head_count_list,:location_id=>'1',:type=>'Support'
      response.should be
    end
    it "should export the search results to excel" do
      Profile.should_receive(:all)
       @controller.should_receive(:render).with(:partial=>'partials/profiles/profile_attributes_for_export', :locals => {:profiles => @profiles},:layout=>false)
       get :export_head_count_results,:location_id=>'1',:type=>'Support'
       response.should be
    end
  end
end

