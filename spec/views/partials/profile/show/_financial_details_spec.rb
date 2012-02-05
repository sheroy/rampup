require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')
describe 'Financial Details' do
  before(:each) do
  @profile=Profile.new(:account_no=>'12345',:pan_no=>'12345',:epf_no=>'12345')
  end
  it "should display the financial information of the employee" do
    assigns[:profile]=@profile
    render :partial=>'partials/profile/show/financial_details',:locals=>{:profile=>@profile}
    response.should be
    response.should have_tag('h3','Financial Details:')
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('td:nth-child(1)') do
          with_tag('h4','Account Number:')
        end
        with_tag('td:nth-child(2)','12345')
      end
      with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)') do
          with_tag('h4','PAN Number:')
        end
        with_tag('td:nth-child(2)','12345')
      end
      with_tag('tr:nth-child(3)') do
        with_tag('td:nth-child(1)') do
          with_tag('h4','EPF Number:')
        end
        with_tag('td:nth-child(2)','KN/BN/35147/12345')
      end
    end
  end
end
