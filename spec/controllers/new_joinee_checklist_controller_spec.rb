require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe NewJoineeChecklistController do

  before :each do
    @profile=ModelFactory.create_profile
  end

  it "should show new joinee checklist page" do
    get :show, :id=>@profile.id
    assert_response :success
  end

  it "should go to the new joinee checklist controller" do
    assert_routing "/newjoineechecklist/show", {:controller=> "new_joinee_checklist", :action => "show"}
  end

  it "should save to database and redirect to edit page" do
    checklist = ModelFactory.create_checklist
    params = {checklist.id.to_s => 'yes', :id => @profile.id}
    post :save, params
    EmployeeChecklistSubmitted.find_all_by_profile_id(params[:id]).count.should be 1
    response.should redirect_to :controller => "profile", :action => "edit"
  end
end