require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe "Access Card Details" do
before(:each) do
  @profile_attributes={:access_card_number=>'1234',:blood_group=>'O',:emergency_contact_person=>'Person',:emergency_contact_number=>'978723'}
  @profile=Profile.new
end
it "should display the access card details correctly" do
    @profile.attributes=@profile_attributes
    render :partial=>'partials/profile/show/access_card_details',:locals=>{:profile=>@profile}
    response.should have_tag('h3','Access Card Details:')
    response.should have_tag('table') do
    with_tag('tr:nth-child(1)') do
    with_tag('td:nth-child(1)','Access Card Number:')
    with_tag('td:nth-child(2)',"#{@profile.access_card_number}")
    end
    with_tag('tr:nth-child(2)') do
    with_tag('td:nth-child(1)','Blood Group:')
    with_tag('td:nth-child(2)',"#{@profile.blood_group}")
    end
    with_tag('tr:nth-child(3)') do
    with_tag('td:nth-child(1)','Emergency Contact Person:')
    with_tag('td:nth-child(2)',"#{@profile.emergency_contact_person}")
    end
    with_tag('tr:nth-child(4)') do
    with_tag('td:nth-child(1)','Emergency Contact Number:')
    with_tag('td:nth-child(2)',"#{@profile.emergency_contact_number}")
    end
  end
end
end  
  
  
  
