require File.dirname(__FILE__) + '/../../spec_helper'

describe "Employee" do

  describe "when logged in as employee" do

    before(:each) do
      @controller.set_current_user(User.new(:role=>"employee"))
      @profile_attributes = {
        :name=>"Name",
        :common_name=>'Common-Name',
        :employee_id=>'12345',
        :date_of_birth=>'06/06/2009',
        :title=>'Application Developer',
        :gender=>'Male',
        :email_id=>'employee',
        :marital_status=>'Single',
        :guardian_name=>'Guardian Name',
        :date_of_joining=>'06/06/2009',
        :last_day=>'06/06/2009',
        :personal_email_id=>'aaa@gmail.com',
        :location_id=>'1',
        :years_of_experience=>'5',
        :type=>'ProfessionalServices',
        :permanent_address_line_1=>'House No 7831/2',
        :permanent_address_line2=>'Street No 9',
        :access_card_number=>'999998'
      }
      @profile = Profile.new
      @controller.stub!(:check_authentication)
    end

      it "should display General Details" do
        @profile.attributes = @profile_attributes
        assigns[:user_profile]=@profile
        render :template=>"home/employee"
        response.should be

        response.should have_tag("table",:id=>"personal_details") do
           with_tag("tr:nth-child(1)") do
            with_tag("td:nth-child(1)",:text=>'Employee Id:')
            with_tag("td:nth-child(2)",:text=>'12345')
           end
        end

        response.should have_tag("table",:id=>"address_details") do
           with_tag("tr:nth-child(2)") do
            with_tag("td:nth-child(1)",:text=>'House No 7831/2')
           end
        end

        response.should have_tag("table",:id=>"access_card_details") do
           with_tag("tr:nth-child(1)") do
            with_tag("td:nth-child(1)",:text=>'Access Card Number:')
            with_tag("td:nth-child(2)",:text=>'999998')
           end
        end
      end

     it "should not display Qualification Details" do
        @profile.attributes = @profile_attributes
        assigns[:user_profile]=@profile
        render :template=>"home/employee"
        response.should_not have_tag("h3", :text=>"Qualifications Details:")
     end


  end
end