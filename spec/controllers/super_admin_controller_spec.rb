require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SuperAdminController do
  before(:each) do
    @controller.stub!(:check_authentication)
     @controller.instance_eval {flash.stub!(:sweep) }
    @post_params = {
      "name"=>'abc',
      "category"=>'category',
      "role"=>'admin'
    }
  end
  describe "manage_fields" do
    it "should display the manage_fields page" do
      get :manage_fields
      response.should be
    end

    it "should add the new role to database" do
        @new_role=ModelFactory.create_titles
        post :add_new_role, :new_field=>@post_params
        actual = Title.find_by_name(@new_role.name)
        actual.should_not be nil
    end

    it "should add the new category to database" do
        @new_category=ModelFactory.create_categories
        post :add_new_category, :new_degree=>@post_params
        actual = Degree.find_by_category(@new_category.category)
        actual.should_not be nil
    end

    it "should add the new category to database" do
        @new_category=ModelFactory.create_categories
        post :add_new_category, :new_degree=>@post_params
        actual = Degree.find_by_category(@new_category.category)
        actual.should_not be nil
    end

    it "should add new admin to database" do
        @new_admin=ModelFactory.create_admin
        post :add_new_admin, :new_admin=>@post_params
        actual = User.find_by_username(@new_admin.username)
        actual.should_not be nil
    end

    it "should delete an existing admin from database" do
        @new_admin=ModelFactory.create_admin
        post :add_new_admin, :new_admin=>@post_params
        post :delete_admin, :id=>@new_admin.username
        admin = User.find_by_username(@new_admin.username)
        admin.should be nil
    end

  end
end
