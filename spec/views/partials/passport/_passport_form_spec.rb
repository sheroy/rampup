require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "passport form partial" do
  it "should display the passport form" do
    @profile = Profile.new
    @passport = Passport.new
    render :partial=>'partials/passport/passport_form', :locals=>{:passport=>@passport, :profile =>@profile}
    response.should be
    response.should have_tag('form') do
      response.should have_tag('table') do
        with_tag('tr:nth-child(1)') do
          with_tag('td:nth-child(1)', "Passport Number:")
          with_tag('td:nth-child(2)') do

          end
        end
        with_tag('tr:nth-child(2)') do
          with_tag('td:nth-child(1)', "Date Of Issue:")
          with_tag('td:nth-child(2)') do

          end
        end
        with_tag('tr:nth-child(3)') do
          with_tag('td:nth-child(1)',"Date Of Expiry:")
          with_tag('td:nth-child(2)') do

          end
        end
        with_tag('tr:nth-child(4)') do
          with_tag('td:nth-child(1)', "Place Of Issue:")
          with_tag('td:nth-child(2)') do
          end
        end
        with_tag('tr:nth-child(5)') do
          with_tag('td:nth-child(1)', "Nationality:")
          with_tag('td:nth-child(2)') do
          end
        end
      end
    end
  end
end