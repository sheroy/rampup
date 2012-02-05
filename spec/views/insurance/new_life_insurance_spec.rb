require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "New Life Insurance" do
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
    
    template.should_receive(:render).with(:partial=>'partials/insurance/life_insurance_form')
    assigns[:profile] = @profile
    assigns[:current_user] = @current_user
    render :template => 'insurance/new_life_insurance'
    response.should be_success
    response.should have_tag('h3',"common name")
    response.should have_tag('h3',"Step 5 of 6 - Life Insurance Information")
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('th:nth-child(1)',"Dependent Name")
        with_tag('th:nth-child(2)',"Relationship with Employee")
        with_tag('th:nth-child(3)',"Percentage")
      end
      @profile.lives.each_with_index do |dependent,i|
        with_tag("tr:nth-child(#{i+2})") do
          with_tag('td:nth-child(1)', "Name")
          with_tag('td:nth-child(2)', "Single")
          with_tag('td:nth-child(3)', "10")
        end
      end
    end
  end
end
