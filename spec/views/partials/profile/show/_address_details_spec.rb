require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

describe "address details partial" do   
  before(:each) do                          
    @profile = mock( "Profile",
    :permanent_address_line_1 => 'line1',
    :permanent_address_line2 => 'line2',
    :permanent_address_line3 => 'line3',
    :permanent_city => 'city',
    :permanent_state => 'state',
    :permanent_pincode => '600024',
    :permanent_phone_number => "23720119",
    :temporary_address_line1 => 'tmp_line1',
    :temporary_address_line2 => 'tmp_line2',
    :temporary_address_line3 => 'tmp_line3',
    :temporary_city => 'tmp_city',
    :temporary_state => 'tmp_state',
    :temporary_pincode => '600025',
    :temporary_phone_number => "23720120"
    ) 
    @controller.stub!(:check_authentication)
  end
  it "should display the current address" do

    render :partial => 'partials/profile/show/address_details', :locals=>{:profile=>@profile}
    response.should be                                  
    
    response.should have_tag('h3', 'Address Details:')
    response.should have_tag('table') do     
     with_tag('tr:nth-child(1)') do
       with_tag('td:nth-child(1)') do
         with_tag('h4','Permanent Address:')
       end
       with_tag('td:nth-child(2)') do
         with_tag('h4','Current Address:')
       end
     end
     with_tag('tr:nth-child(2)') do
       with_tag('td:nth-child(1)','line1')
       with_tag('td:nth-child(2)','tmp_line1')
     end
      with_tag('tr:nth-child(3)') do
       with_tag('td:nth-child(1)','line2')
       with_tag('td:nth-child(2)','tmp_line2')
     end
      with_tag('tr:nth-child(4)') do
       with_tag('td:nth-child(1)','line3')
       with_tag('td:nth-child(2)','tmp_line3')
     end
      with_tag('tr:nth-child(5)') do
       with_tag('td:nth-child(1)','city')
       with_tag('td:nth-child(2)','tmp_city')
     end
      with_tag('tr:nth-child(6)') do
       with_tag('td:nth-child(1)','state')
       with_tag('td:nth-child(2)','tmp_state')
     end
      with_tag('tr:nth-child(7)') do
       with_tag('td:nth-child(1)','600024')
       with_tag('td:nth-child(2)','600025')
     end
      with_tag('tr:nth-child(8)') do
       with_tag('td:nth-child(1)','Residence Phone:23720119')
       with_tag('td:nth-child(2)','Mobile Phone:23720120')
     end
    end

  end
end