require "spec_helper"

describe "Medical Insurance List" do
  before :each do
    medical = ModelFactory.create_medical_dependent
    medical.id = 10
    @profile = mock "Profile mock", :id => 123, :medicals => [medical]
  end

  context "if the user is an admin" do
    before :each do
      assigns[:current_user] = User.new :role => "admin"
      render :partial => "partials/insurance/existing_medical", :locals => {:profile => @profile}
    end

    it "should allow to see the edit button" do
      response.should have_tag "a[href=/insurance/123/edit_medical_insurance/10]", :text => "Edit"
    end

    it "should allow to see the delete button" do
      response.should have_tag "a[href=/insurance/123/delete_medical_insurance/10]", :text => "Delete"
    end
  end

  context "if the user is a superadmin" do
    before :each do
      assigns[:current_user] = User.new :role => "superadmin"
      render :partial => "partials/insurance/existing_medical", :locals => {:profile => @profile}
    end

    it "should allow to see the edit button" do
      response.should have_tag "a[href=/insurance/123/edit_medical_insurance/10]", :text => "Edit"
    end

    it "should allow to see the delete button" do
      response.should have_tag "a[href=/insurance/123/delete_medical_insurance/10]", :text => "Delete"
    end
  end
end