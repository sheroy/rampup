require "spec_helper"

describe "InsuranceView" do
  before(:each) do
    @current_user = mock("user",
      :role => 'employee',
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
      :medicals=>[@medical_insurance],
      :lives=>[@life_insurance]
    )
    
    assigns[:profile] = @profile
    assigns[:current_user] = @current_user
  end

  it "should display life insurance details" do
      template.should_receive(:render).with(:partial => 'partials/insurance/life_insurance_list', :locals => {:profile => @profile})
      
      render :template => 'insurance/show_insurance'
  end
  
  it "should display medical insurance details" do
      template.should_receive(:render).with(:partial => 'partials/insurance/existing_medical', :locals => {:profile => @profile})
      
      render :template => 'insurance/show_insurance'
  end
  
  it "should display the details for updating the life insurance details" do
    template.should_receive(:render).with(:partial => 'partials/insurance/change_insurance_details', :locals => {:profile => @profile})
    
    render :template => 'insurance/show_insurance'
  end
end