require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "add visa" do
  it "should display the form for adding visa information" do
    @visa = Visa.new
    @profile = Profile.new
    assigns[:profile] = @profile
    render :partial=>'partials/visa/add_visa', :locals=>{:visa=>@visa}
    response.should be_success
    response.should have_tag('h3', "Add New Visa Information")

    response.should have_tag('table') do
      
      with_tag('tr:nth-child(1)') do
        with_tag('td:nth-child(1)', "Visa Category:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)', "Visa Status:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(3)') do
        with_tag('td:nth-child(1)', "Issue Date:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(4)') do
        with_tag('td:nth-child(1)', "Expiry Date:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(5)') do
        with_tag('td:nth-child(1)', "Reason:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(6)') do
        with_tag('td:nth-child(1)', "Visa Type:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(7)') do
        with_tag('td:nth-child(1)', "Appointment Date:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(8)') do
        with_tag('td:nth-child(1)', "Travel By:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(9)') do
        with_tag('td:nth-child(1)', "Date Of Return:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(10)') do
        with_tag('td:nth-child(1)', "Petition Status:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(11)') do
        with_tag('td:nth-child(1)', "Timeline:")
        with_tag('td:nth-child(2)') do
        end
      end
      with_tag('tr:nth-child(12)') do
        with_tag('td:nth-child(1)', "Country:")
      end
    end
  end
end