require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ImmigrationController do
  integrate_views
  before(:each) do
     ROLES=["Application Developer"] unless defined?(ROLES)
     profile= ModelFactory.create_profile()
    profile.passport=ModelFactory.create_passport(:profile_id=>profile.id)
    profile.visas<<ModelFactory.create_visa()
  end
  it "should give the profiles based on the query" do
    get :search, :location=>'',:title=>'',:name=>'',:visa_type=>''
    response.should render_template('search')
    response.should be_success
  end
  it "should give the profiles for exporting to excel" do
    @controller.should_receive(:render).with(:partial=>'partials/immigration/immigration_results',:layout=>false)
    get :export_search_results,:location=>'',:title=>'',:name=>'',:visa_type=>''
    response.should be
  end
end