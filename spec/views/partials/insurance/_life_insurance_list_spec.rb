require "spec_helper"

describe "Life Insurance List" do
  before :each do
    life = ModelFactory.create_life_insurance_beneficiary
    life.id = 10
    assigns[:profile] = mock "Profile mock", :id => 123, :lives => [life]
  end

  context "if the user is an admin" do
    before :each do
      assigns[:current_user] = User.new :role => "admin"
      render :partial => "partials/insurance/life_insurance_list"
    end

    it "should allow to see the edit button" do
      response.should have_tag "a[href=/insurance/123/edit_life_insurance/10]", :text => "Edit"
    end

    it "should allow to see the delete button" do
      response.should have_tag "a[href=/insurance/123/delete_life_insurance/10]", :text => "Delete"
    end
  end

  context "if the user is a superadmin" do
    before :each do
      assigns[:current_user] = User.new :role => "superadmin"
      render :partial => "partials/insurance/life_insurance_list"
    end

    it "should allow to see the edit button" do
      response.should have_tag "a[href=/insurance/123/edit_life_insurance/10]", :text => "Edit"
    end

    it "should allow to see the delete button" do
      response.should have_tag "a[href=/insurance/123/delete_life_insurance/10]", :text => "Delete"
    end
  end

end