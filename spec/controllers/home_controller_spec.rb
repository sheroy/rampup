require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  def setup
  end

  #test "render index if have read ability on project" do
  #  @ability.can :read, Project
  #  get :index
  #  assert_template :index
  #end
  #
  before(:each) do
    @project = mock("project")
    @projects = [@project,@project]
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.can :manage, :all
    @controller.stub!(:current_ability).and_return(@ability)
  end

  it "should render the home page for the admin" do
    Profile.should_receive(:all).with(:limit=>5, :order=>'date_of_joining desc')
    Distribution::AdminDistribution.should_receive(:head_count_breakdown)
    get :admin
    response.should be_success
  end

  it "should redirect to admin home page for admin user" do
    @controller.set_current_user(User.new(:username=>"admin", :password=>"pass", :role=>"admin"))
    get :index
    response.should redirect_to admin_home_path
  end

  it "should export the excel file with head count breakdown" do
    Distribution::AdminDistribution.should_receive(:head_count_breakdown)
    @controller.should_receive(:render).with(:partial=>'partials/home/breakdowns/head_count',
      :locals=>{:head_count_breakdown=>@head_count_breakdown,:employee_type=>@employee_type,:places=>@places},:layout=>false)
    get :head_count_distribution_exporter
    response.should be
  end

  describe "Home controller" do
    integrate_views
    before(:each) do
      ModelFactory.create_profile(:years_of_experience=>12, :date_of_joining=>DateTime.now - 1.year, :employee_id=>'12121', :location => "Chennai")
      ModelFactory.create_profile(:years_of_experience=>12, :date_of_joining=>DateTime.now - 1.year, :employee_id=>'33333', :location => "Bangalore")
      ModelFactory.create_profile(:years_of_experience=>24, :date_of_joining=>DateTime.now - 1.year, :employee_id=>'44444', :location => "Pune")
      
      ModelFactory.create_resource(:EmployeeID => '12121',:DateOfJoining=>DateTime.now - 1.year, :ResourceID => "ResourceID1",:LocationID=>'LocationID')
      ModelFactory.create_resource(:EmployeeID => '33333',:DateOfJoining=>DateTime.now - 1.year, :ResourceID => "ResourceID2",:LocationID=>'LocationID1')
      ModelFactory.create_resource(:EmployeeID => '44444',:DateOfJoining=>DateTime.now - 1.year, :ResourceID => "ResourceID3",:LocationID=>'LocationID2')
      ModelFactory.create_location(:Name=>'Chennai')
      ModelFactory.create_location(:Name=>'Bangalore')
      ModelFactory.create_location(:Name=>'Pune')
    end
  end



end