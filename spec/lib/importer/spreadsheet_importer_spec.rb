require 'spec_helper'
require 'spreadsheet'
describe Importer::SpreadsheetImporter do

  describe "spreadsheet" do

    before(:each) do
       @chennai_location = ModelFactory.create_location(:name => "Chennai", :countries_id => '2')
    end


    describe "spreadsheet import with valid data" do

      before(:each) do
        @profile = Importer::SpreadsheetImporter.import("#{Rails.root}/spec/data/Spreadsheet_with_data.xls", "82794", "abc@thoughtworks.com")
      end

      it "should import and create new record if not already available" do
        @profile.should_not be nil
      end

      it "should map all values in profile object from the actual spreadsheet" do
        @profile.name.should == "Mei"
        @profile.surname.should == "yang"
        @profile.common_name.should == "Meiyang"
        @profile.gender.should == "Female"
        @profile.marital_status.should == "Single"
        @profile.permanent_address_line_1.should == "Diamond District"
        @profile.permanent_city.should == "Bangalore"
        @profile.permanent_state.should == "Karnataka"
        @profile.permanent_pincode.should == "123456"
        @profile.temporary_address_line1.should == "Diamond District"
        @profile.temporary_city.should == "Bangalore"
        @profile.temporary_state.should == "Karnataka"
        @profile.temporary_pincode.should == "123456"
        @profile.temporary_phone_number.should == 987654321
        @profile.personal_email_id.should == "thoughtworker@gmail.com"
        @profile.years_of_experience.should == 6
        @profile.permanent_phone_number.should == 987654321
        @profile.blood_group.should == "B+"
        @profile.emergency_contact_person.should == "Mr Yang"
        @profile.emergency_contact_number.should == 123456789
        @profile.location_id == @chennai_location.id
        @profile.date_of_birth.to_date.should == "1985/08/28".to_date
        @profile.date_of_joining.to_date.should == "1991/08/28".to_date
      end

      it "should map passport details in profile object from the actual spreadsheet" do
        passport = @profile.passport
        passport.number.should == "1234567"
        passport.nationality.should == "UK"
      end

      it "should map experience details in profile object from the actual spreadsheet" do
        experience = @profile.experiences.collect
        experience[0].technology.should == "C++"
      end

      it "should map qualification details in profile object from the actual spreadsheet" do
        qualification = @profile.qualifications.collect
        qualification.size.should == 2
        qualification[0].category.should == "Bachelors-Engg"
        qualification[1].category.should == "Bachelors-Mgmt"
      end

      it "should map life insurance details in profile object from the actual spreadsheet" do
        life_dependent = @profile.dependents.collect
        life_dependent.size.should == 3
        life_dependent[0].name.should == "Mokut"
        life_dependent[1].name.should == "Mohan"
        life_dependent[2].name.should == "mei"
      end

      it "should map medical insurance details in profile object from the actual spreadsheet" do
        medical_dependent = @profile.dependents.collect
        medical_dependent.size.should == 3
        medical_dependent[0].name.should == "Mokut"
        medical_dependent[1].name.should == "Mohan"
        medical_dependent[2].name.should == "mei"
      end

      it "should map financial details in profile object from the actual spreadsheet" do
        @profile.pan_no.should == "908ABE2378GH23CD8321"
      end
    end


    describe "spreadsheet import with invalid data" do

      before(:each) do
        @profile = Importer::SpreadsheetImporter.import("#{Rails.root}/spec/data/Spreadsheet_with_wrong_data.xls", "82794", "abc@thoughtworks.com")
      end

      it "should fail import using spreadsheet with wrong data" do
        @profile.should_not be_nil
        @profile.employee_id.should == "82794"
        @profile.name.should == ""
      end

      it "should create profile type as a Professional Service by default" do
        @profile.class.should be ProfessionalServices
      end

      it "should not create the passport if the spreadsheet passport number field is nil" do
        @profile.passport.should be_nil
      end

    end

  end

end