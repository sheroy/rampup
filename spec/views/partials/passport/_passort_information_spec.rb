require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "passport information" do
  it "should display the passport information" do
    @passport = mock("passport",
    :number => '11111',
    :date_of_issue=>Time.parse('10/10/2009'),
    :date_of_expiry=>Time.parse('10/10/2009'),
    :place_of_issue=>'Chennai',
    :nationality=>'Indian'
    )
    render :partial=>'partials/passport/passport_information', :locals=>{:passport=>@passport}
    response.should be
    response.should have_tag('table') do
      with_tag('tr:nth-child(1)') do
        with_tag('td:nth-child(1)',"Passport Number:")
        with_tag('td:nth-child(2)',"11111")
      end
      with_tag('tr:nth-child(2)') do
        with_tag('td:nth-child(1)',"Date Of Issue:")
        with_tag('td:nth-child(2)',"10-Oct-2009")
      end
      with_tag('tr:nth-child(3)') do
        with_tag('td:nth-child(1)',"Date Of Expiry:")
        with_tag('td:nth-child(2)','10-Oct-2009')
      end
      with_tag('tr:nth-child(4)') do
        with_tag('td:nth-child(1)', "Place Of Issue:")
        with_tag('td:nth-child(2)',"Chennai")
      end
      with_tag('tr:nth-child(5)') do
        with_tag('td:nth-child(1)',"Nationality:")
        with_tag('td:nth-child(2)',"Indian")
      end
    end
  end
end