require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Account Details" do
  it "should display the financial form information" do
    @profile = mock("Profile", :common_name=>'Common Name', :account_no => '1', :pan_no => '1', :epf_no=>'1' ,:id=>1)
    assigns[:profile] = @profile
    render :template => 'profile/financial_details'
    response.should be
    response.should have_tag('h3', "Common Name")
    response.should have_tag('h3', "Step 6 of 6 - Financial Information")
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('td:nth-child(1)', "Bank Account No:")
      end
      with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)', "PAN No:*")
      end
      with_tag('tr:nth-child(3)') do
        with_tag('td:nth-child(1)', "EPF No: KN/BN/35147/")
      end
    end
  end
end