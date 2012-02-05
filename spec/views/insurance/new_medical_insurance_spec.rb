require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe "New Medical Insurance" do
  it "should display the form" do
    @current_user = mock("user",
      :role => 'admin',
      :username => 'jesus'
    )
    @medical_insurance=mock("medical insurance",
      :id => 1, 
      :name=>'Name',
      :date_of_birth=>DateTime.parse("10/10/2009"),
      :age=>'5',
      :relationship=>'Single'
    )
    @life_insurance=mock("life insurance",
      :id => 1,
      :name=>'Name',
      :relationship=>'relation',
      :percentage=>10,
      :date_of_birth=>DateTime.parse("10/10/2009")
    )
    @profile = mock("profile", 
      :id=>1,
      :common_name => 'common name',
      :medicals=>[@medical_insurance],
      :lives=>[@life_insurance]
    )
    
    user = mock(User)
    @controller.stub!(:current_user).and_return(user)
    user.stub!(:role).and_return(:admin)
    
    assigns[:profile]=@profile
    assigns[:medical]=@medical_insurance
    assigns[:current_user] = @current_user
    
    template.should_receive(:render).with(:partial=>'partials/insurance/existing_medical',:locals=>{:profile=>@profile})
    render :template=>'insurance/new_medical_insurance'
    response.should be_success
    response.should have_tag('h3','common name')
  end
end