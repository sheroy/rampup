require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProfilesController do
  before(:each) do
    @controller.stub!(:check_authentication)
  end


  describe ProfilesController do

    it "should recognize search route" do
      route_for(:controller => "profiles", :action => "search", 
      :search_terms => "search-terms").should == "/profiles/search/search-terms"
    end
  end

  describe "index" do

    it "should call find all when there is no search term provided" do
      Profile.should_receive(:paginate).with({:order=>"date_of_joining DESC,employee_id DESC", :page=>1, :per_page=>10, :conditions=>["completed=? and last_day is NULL and employee_id is NOT NULL", true]}).and_return([@profile])
      @controller.should_receive(:render).with(:template => "profiles/search_results")
      get :index
    end

    it "should call find all incomplete profile when there is no search term provided and if imcompleted is passed" do
      Profile.should_receive(:paginate).with({:order=>"date_of_joining DESC,employee_id DESC", :page=>1, :per_page=>10, :conditions=>["completed=? and last_day is NULL and employee_id is NOT NULL", false]}).and_return([@profile])
      @controller.should_receive(:render).with(:template => "profiles/search_results")
      get :index, :incomplete => true
    end

    describe "view" do
      integrate_views
      before(:each) do
        @paginated_profiles = mock("profiles", :total_pages => 1, :length => 1, :each_with_index => @profiles)
      end

      it "should render profiles list first page if page parameter is missing" do
        Profile.should_receive(:paginate).with({:order=>"date_of_joining DESC,employee_id DESC", :page=>1, :per_page=>10, :conditions=>["completed=? and last_day is NULL and employee_id is NOT NULL", true]}).and_return(@paginated_profiles)
        @paginated_profiles.stub!(:each)
        # @paginated_profiles.stub!(:size)
        get :index
        response.should be_success
        assigns[:profiles].should == @paginated_profiles
      end

      it "should render nth page in profiles list " do
        n = "3"
        Profile.should_receive(:paginate).with({:order=>"date_of_joining DESC,employee_id DESC", :page=>"3", :per_page=>10, :conditions=>["completed=? and last_day is NULL and employee_id is NOT NULL", true]}).and_return(@paginated_profiles)
        @controller.should_receive(:render).with(:template => "profiles/search_results")
        get :index, :page => n
        assigns[:profiles].should == @paginated_profiles
      end
    end

  end

describe "search" do
  integrate_views

    it "should display results" do
      Profile.should_receive(:find_search_parameters).with("search-term").and_return([@profile])
      @controller.should_receive(:render).with(:template => "profiles/profiles_list")
      get :search, :search_terms=>'search-term'
    end
  end     

  describe "profiles lister" do
    describe "latest updates" do
      it "should get the recent set of updates" do
        Profile.should_receive(:paginate).with(:limit=>10,:order=>'updated_at DESC', :page=>1, :per_page=>10).and_return([@profile])
        @controller.should_receive(:render).with(:template=>'profiles/profiles_list')
        get :recent
      end
    end

    describe "recently created profiles" do
      it "should get the recently created profiles" do
        Profile.should_receive(:paginate).with(:limit=>10,:order=>'created_at DESC', :page=>1, :per_page=>10).and_return([@profile])
        @controller.should_receive(:render).with(:template=>'profiles/profiles_list')
        get :created
      end
    end

    it "should display the paginated list of recently joined employees" do
      Profile.should_receive(:paginate).with(:order=>'date_of_joining DESC',:conditions=>["last_day is NULL and employee_id is NOT NULL"],
      :limit=>10, :page=>params[:page]||1, :per_page=>10)
      @controller.should_receive(:render).with(:template=>'profiles/profiles_list')
      get :newly_joined      
    end

  end

end