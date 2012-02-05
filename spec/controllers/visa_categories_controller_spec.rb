require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VisaCategoriesController do

  def mock_visa_category(stubs={})
    @mock_visa_category ||= mock_model(VisaCategory, stubs)
  end

  describe "responding to GET index" do

    it "should expose all visa_categories as @visa_categories" do
      VisaCategory.should_receive(:find).with(:all).and_return([mock_visa_category])
      get :index
      assigns[:visa_categories].should == [mock_visa_category]
    end
  end

  describe "responding to GET new" do

    it "should expose a new visa_category as @visa_category" do
      VisaCategory.should_receive(:new).and_return(mock_visa_category)
      get :new
      assigns[:visa_category].should equal(mock_visa_category)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested visa_category as @visa_category" do
      VisaCategory.should_receive(:find).with("37").and_return(mock_visa_category)
      get :edit, :id => "37"
      assigns[:visa_category].should equal(mock_visa_category)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created visa_category as @visa_category" do
        VisaCategory.should_receive(:new).with({'these' => 'params'}).and_return(mock_visa_category(:save => true))
        post :create, :visa_category => {:these => 'params'}
        assigns(:visa_category).should equal(mock_visa_category)
      end

      it "should redirect to the created visa_category" do
        VisaCategory.stub!(:new).and_return(mock_visa_category(:save => true))
        post :create, :visa_category => {}
        response.should redirect_to(visa_category_url(mock_visa_category))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved visa_category as @visa_category" do
        VisaCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_visa_category(:save => false))
        post :create, :visa_category => {:these => 'params'}
        assigns(:visa_category).should equal(mock_visa_category)
      end

      it "should re-render the 'new' template" do
        VisaCategory.stub!(:new).and_return(mock_visa_category(:save => false))
        post :create, :visa_category => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested visa_category" do
        VisaCategory.should_receive(:find).with("37").and_return(mock_visa_category)
        mock_visa_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :visa_category => {:these => 'params'}
      end

      it "should expose the requested visa_category as @visa_category" do
        VisaCategory.stub!(:find).and_return(mock_visa_category(:update_attributes => true))
        put :update, :id => "1"
        assigns(:visa_category).should equal(mock_visa_category)
      end

      it "should redirect to the visa_category" do
        VisaCategory.stub!(:find).and_return(mock_visa_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(visa_category_url(mock_visa_category))
      end

    end

    describe "with invalid params" do

      it "should update the requested visa_category" do
        VisaCategory.should_receive(:find).with("37").and_return(mock_visa_category)
        mock_visa_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :visa_category => {:these => 'params'}
      end

      it "should expose the visa_category as @visa_category" do
        VisaCategory.stub!(:find).and_return(mock_visa_category(:update_attributes => false))
        put :update, :id => "1"
        assigns(:visa_category).should equal(mock_visa_category)
      end

      it "should re-render the 'edit' template" do
        VisaCategory.stub!(:find).and_return(mock_visa_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested visa_category" do
      VisaCategory.should_receive(:find).with("37").and_return(mock_visa_category)
      mock_visa_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the visa_categories list" do
      VisaCategory.stub!(:find).and_return(mock_visa_category(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(visa_categories_url)
    end

  end

end
