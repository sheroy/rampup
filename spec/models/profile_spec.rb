require File.dirname(__FILE__) + '/../spec_helper'
require 'model_factory'

describe Profile do
  before(:each) do
    @profile = Profile.new
    @valid_attributes = {
        :employee_id => '11111',
        :name=>'usha',
        :surname=>'c',
        :common_name=>'usha c',
        :title=>'Application Developer',
        :gender=>'female',
        :marital_status=>'single',
        :permanent_address_line_1=>'karur',
        :permanent_address_line2=>' ',
        :permanent_address_line3=>' ',
        :permanent_city=>'karur',
        :permanent_state=>'tamil nadu',
        :permanent_pincode=>'123456',
        :temporary_address_line1=>'chennai',
        :temporary_address_line2=>' ',
        :temporary_address_line3=>' ',
        :temporary_city=>'chennai',
        :temporary_state=>'tamil nadu',
        :temporary_pincode=>'123456',
        :guardian_name=>'niveditha',
        :location_id=>"4",
        :date_of_joining=>Time.now,
        :transfer_date=>Time.now,
        :transfer_from=>'bangalore',
        :transfer_to=>'chennai',
        :date_of_birth=>Time.now,
        :years_of_experience=>320,
        :email_id=>'nivedis',
        :personal_email_id=>'aaa@gmail.com',
        :permanent_phone_number=>"12345678",
        :temporary_phone_number=>"12345678",
        :emergency_contact_number=>'986568556',
        :emergency_contact_person=>'aafaf',
        :blood_group=>'B+',
        :type=>"Etg",
        :pan_no=>"ABX98473"
    }
  end

  it "should be valid" do
    @profile.attributes = @valid_attributes
    @profile.qualifications << ModelFactory.create_qualification()
    @profile.should be_valid
  end

  describe "years of experience" do
    it "should be a valid number" do
      @profile.attributes = @valid_attributes
      @profile.years_of_experience = "Wrong Input"
      @profile.should_not be_valid
      @profile.errors[:years_of_experience].should == ["not a valid number"]
    end
  end

  describe "marital status" do
    it "should not be valid if marital status is not present" do
      @invalid_attributes=@valid_attributes
      @invalid_attributes.delete :marital_status
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
      @profile.errors[:marital_status].should_not be_nil
    end
  end

  describe "employee id" do

    it "should be valid" do
      @profile.attributes = @valid_attributes
      @profile.qualifications << ModelFactory.create_qualification()
      @profile.should be_valid
    end

    it "should be unique" do
      profile1 = Profile.new(@valid_attributes)
      profile1.qualifications << ModelFactory.create_qualification()
      profile1.save!

      profile2 = Profile.new(@valid_attributes)
      profile2.qualifications << ModelFactory.create_qualification()

      profile2.should_not be_valid
    end

    describe "should not be valid if the length doesn't equal five" do

      before(:each) do
        @invalid_attributes = @valid_attributes
      end

      after(:each) do
        @profile.attributes = @invalid_attributes
        @profile.should_not be_valid
        @profile.errors[:employee_id].should eql(["should be of length 5"])
      end

      it "if it is less than 5 digits" do
        @invalid_attributes[:employee_id] = 1234
      end

      it "if its greater than 5 digits" do
        @invalid_attributes[:employee_id] = 123456
      end

      it "if its negative" do
        @invalid_attributes[:employee_id] = -12345
      end
    end

    describe "should be invalid if employee_id is non-numeric" do
      before(:each) do
        @invalid_attributes = @valid_attributes
      end

      after(:each) do
        @profile.attributes = @invalid_attributes
        @profile.should_not be_valid
        @profile.errors[:employee_id].should eql(["should be of length 5", "should be a number"])
      end

      it "if its blank" do
        @invalid_attributes[:employee_id]= ""
      end

      it "if its nil" do
        @invalid_attributes.delete :employee_id
      end

      it "if it is not a number" do
        @invalid_attributes[:employee_id]= "ABC"
      end
    end
  end

  describe "address" do
    before(:each) do
      @invalid_attributes=@valid_attributes
    end
    after(:each) do
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
    end
    describe "permanent address" do
      it "should contain atleast 1st address lane " do
        @invalid_attributes.delete :permanent_address_line_1
      end
      it "should contain city" do
        @invalid_attributes.delete :permanent_city
      end
      it "should contain state" do
        @invalid_attributes.delete :permanent_state
      end
      it "should contain pincode" do
        @invalid_attributes.delete :permanent_pincode
      end
    end
    describe "temporary address" do
      it "should contain atleast one address line" do
        @invalid_attributes.delete :temporary_address_line1
      end
      it "should contain city" do
        @invalid_attributes.delete :temporary_city
      end
      it "should contain state" do
        @invalid_attributes.delete :temporary_state
      end
      it "should contain pincode" do
        @invalid_attributes.delete :temporary_pincode
      end
    end
  end
  describe "location" do
    before(:each) do
      @invalid_attributes=@valid_attributes
    end
    it "should not be valid if the location is not present" do
      @invalid_attributes.delete :location_id
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
      @profile.errors[:location_id].should eql(["mandatory"])
    end
  end
  describe "title" do

    before(:each) do
      @invalid_attributes = @valid_attributes
    end

    after(:each) do
      @profile.attributes = @invalid_attributes
      @profile.should_not be_valid
      @profile.errors[:title].should eql(["mandatory"])
    end

    it "should not be valid if title is not present" do
      @invalid_attributes.delete :title
    end

    it "should not be valid if title is empty string" do
      @invalid_attributes[:title] = ""
    end
  end

  describe "pincode" do
    before(:each) do
      @invalid_attributes = @valid_attributes
    end

    it "should have a valid pin code with proper length" do

      @invalid_attributes.delete :permanent_pincode
      @profile.attributes = @invalid_attributes
      @profile.permanent_pincode = "233"
      @profile.should_not be_valid
      @profile.errors[:permanent_pincode].should eql(["should be of length 6"])
    end

    it "should have a valid numeric pincode " do

      @profile.attributes=@valid_attributes
      @profile.permanent_pincode="jdhas"
      @profile.should_not be_valid
      @profile.errors[:permanent_pincode].should eql(["should be a number", "should be of length 6"])
    end
  end

  describe "save" do

    it "with validation" do
      success, profile = Profile.create_or_update(@valid_attributes, true)
      Profile.count.should == 1
      profile.completed.should == true
    end


    it "without validation" do

      @invalid_attributes = @valid_attributes
      @invalid_attributes.delete :common_name

      success, profile = Profile.create_or_update(@invalid_attributes, false)
      Profile.count.should == 1
      profile.completed.should == false

    end
  end

  describe "date" do
    before(:each) do
      @invalid_attributes=@valid_attributes
    end
    after(:each) do
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
    end
    it "should contain date of joining" do
      @invalid_attributes.delete :date_of_joining
    end
    it "should contain date of birth" do
      @invalid_attributes.delete :date_of_birth
    end
  end

  describe "name" do
    before(:each) do
      @invalid_attributes=@valid_attributes
    end
    after(:each) do
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
    end
    it "should not be valid without name" do
      @invalid_attributes.delete :name
    end
    it "should not be valid without surname" do
      @invalid_attributes.delete :surname
    end
  end
  describe "personal email id" do
    it "should not valid without personal email id" do
      @invalid_attributes=@valid_attributes
      @invalid_attributes.delete :personal_email_id
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
    end

    it "should not be valid without a valid personal email id" do
      @invalid_attributes=@valid_attributes
      @invalid_attributes[:personal_email_id] = "blah.b ah."
      @profile.attributes=@invalid_attributes
      @profile.should_not be_valid
    end
  end
  describe "phone number" do
    before(:each) do
      @invalid_attributes=@valid_attributes
      @profile.attributes=@invalid_attributes
    end
    it "should not be valid if not numeric(permanent phone number)" do
      @profile.permanent_phone_number="not a number"
      @profile.should_not be_valid
      @profile.errors[:permanent_phone_number].should eql(["should be a number"])
    end
    it "should not be valid if not numeric(temporary phone number)" do
      @profile.temporary_phone_number="not a number"
      @profile.should_not be_valid
      @profile.errors[:temporary_phone_number].should eql(["should be a number"])
    end
  end

  describe "experience" do
    before(:each) do
      @experience1=Experience.new(:technology=>'.Net', :duration=>5)
      @experience2=Experience.new(:technology=>'Ruby', :duration=>5)
      @profile.attributes=@valid_attributes
      @profile.save
      @profile.experiences<<@experience1
      @profile.experiences<<@experience2
    end
    it "should find the past experience in some technology" do
      @profile.past_experience_in(".Net").should==150.days
    end
    it "should find whether a person has experience in particular technology" do
      @profile.has_past_experience_in("Ruby").should==true
    end

    it "should return table with other technology, duration, and last used of a given profile" do
      @experience3=Experience.new(:technology=>'C++', :duration=>5, :last_used=>'2002-2-2')
      profile=ModelFactory.create_profile
      ModelFactory.create_experience({:technology => "java", :last_used => "2009-10-10", :duration=> 2, :profile_id => profile.id})
      ModelFactory.create_experience({:technology => "C++", :last_used => "2009-10-10", :duration=> 2, :profile_id => profile.id})
      experiences=profile.get_other_technologies_experience_by_profile_id(profile.id)
      experiences.find {|s| s[:technology] == "C++" }.should be_true
      experiences.find {|s| s[:technology] == "java" }.should_not be_true
    end

  end
  
  # describe "qualification" do
  #     before(:each) do
  #       @experience1=Experience.new(:technology=>'.Net', :duration=>5)
  #       @experience2=Experience.new(:technology=>'Ruby', :duration=>5)
  #       @profile.attributes=@valid_attributes
  #       @profile.save
  #       @profile.experiences<<@experience1
  #       @profile.experiences<<@experience2
  #     end
  #     it "should find the past experience in some technology" do
  #       @profile.past_experience_in(".Net").should==150.days
  #     end
  #     it "should find whether a person has experience in particular technology" do
  #       @profile.has_past_experience_in("Ruby").should==true
  #     end
  #   end
  
  describe "filters" do
    before(:each) do
      @profile.attributes=@valid_attributes
      @profile.qualifications << ModelFactory.create_qualification()
      @profile.save
      @valid_attributes[:employee_id]="12345"

      @profile1=Profile.new
      @profile1.attributes=@valid_attributes
      @profile1.qualifications << ModelFactory.create_qualification()
      @profile1.save
    end

    it "should return the profiles which have the specified role and location" do
      Profile.role_in_location("Application Developer", 4).should == [@profile, @profile1]
    end
  end

  it "should mark the profile as complete" do
    @profile.attributes=@valid_attributes
    @profile.save
    @profile.completed.present?.should==false
    @profile.mark_as_complete
    @profile.completed.should==true
  end

  it "should raise error if the date of resignation is less than the date of joining" do
    @profile.attributes = @valid_attributes
    @profile.date_of_joining = DateTime.now
    @profile.last_day = DateTime.now - 20
    @profile.save
    @profile.errors[:last_day].should eql(["cannot be less than date of joining"])
  end

  it "should not raise error if valid resignation date" do
    @profile.attributes = @valid_attributes
    @profile.date_of_joining = DateTime.now
    @profile.last_day = DateTime.now + 20
    @profile.save
    @profile.errors[:last_day].should == []
  end

  it "should give the count based on the title and category" do
    profile1=ModelFactory.create_profile()
    profile2= ModelFactory.create_profile(attr = {:location_id => "4", :employee_id => "45678"},  qualification_attrs = {:category => "category2"})

    qualification_by_category_records = Profile.qualification_category_in_location
    qualification_by_category_records.size.should == 2

    first_record = qualification_by_category_records.first
    first_record.head_count.should == 1 and first_record.category.should=="category1" and first_record.location_id.should== 1

    last_record = qualification_by_category_records.last
    last_record.head_count.should == 1 and last_record.category.should=="category2" and last_record.location_id.should== 4

  end

  it "should return the employees whose date of joining lies in the given date range" do
    profile=Profile.new
    profile.attributes=@valid_attributes
    profile.qualifications<<ModelFactory.create_qualification()
    profile.date_of_joining=Date.today
    profile.save!
    profile1=ModelFactory.create_profile(:employee_id=>'00000')
    profiles=Profile.get_profile_within_the_date_range(Date.today-10, Date.today+10)
    profiles.size.should==1
  end
  it "should return the employees who quit the company within the given date range" do
    profile=Profile.new
    profile.attributes=@valid_attributes
    profile.qualifications<<Qualification.new(:graduation_year => "2005", :branch=>"msc", :college=>"CIT", :degree=>"Msc", :category=>"PG-Engineering")
    profile.date_of_joining=Date.today-20
    profile.last_day=Date.today
    profile.save!
    profile1=ModelFactory.create_profile(:employee_id=>'00000')
    profiles=Profile.get_exit_employees_within_given_date_range(Date.today-10, Date.today+10)
    profiles.size.should==1
  end

  describe "" do
    before(:each) do
      profile = ModelFactory.create_profile(:employee_id=>'00001')
      profile1 = ModelFactory.create_profile(:employee_id=>'00002')
      passport1 = ModelFactory.create_passport(:date_of_expiry=>Time.now+2.months, :profile_id=>profile1.id)

    end
    it "should return employees who do not have passport" do
      profiles=Profile.get_employees_with_no_passport()
      profiles.size.should == 1
    end
    it "should return employeee whose passports are expiring in the next 8 months" do
      Profile.expiring_passports.size.should == 1
    end

    it "should return employees whose passports have expired" do
      profile3 = ModelFactory.create_profile(:employee_id=>'00003')
      passport2 = ModelFactory.create_passport(:date_of_expiry=>Time.zone.today.to_date-2.months, :profile_id=>profile3.id)
      profiles=Profile.get_employees_whose_passports_have_expired()
      profiles.size.should == 1
    end
  end

  it "should return all the birthday babies for a month and location" do
    profile = ModelFactory.create_profile(:date_of_birth=>DateTime.now.to_date)
    profile1 = ModelFactory.create_profile(:employee_id=>'00088', :date_of_birth=>DateTime.now.to_date, :common_name=>"nivedita")
    profiles = Profile.get_birthday_babies(DateTime.now.month.to_s, '1')
    profiles.size.should==2
    profiles.last.common_name.should == "nivedita"
    profiles.first.common_name.should == "Mohan"
  end

  describe "immigration advanced search" do

    before(:each) do
      @title1 = Title.new(:name=>'Application Developer')
      @title2 = Title.new(:name=>'Recruiter')
      @title1.save()
      @title2.save()
      @profile = ModelFactory.create_profile()
      @profile.visas << ModelFactory.create_visa()
      @date_expiry = Date.parse('10-10-2020')
      @profile.passport=ModelFactory.create_passport(:profile_id=>@profile.id, :date_of_expiry => @date_expiry)
    end

    it "should return those who have h1b visas" do
      Location.should_receive(:get_all_location_ids).and_return([1])
      profiles=Profile.immigration_advanced_search('', '', '', 'H1B', 1, 'paginate')
      profiles.size.should == 1
      profiles.first.passport_number.should =='PN12345'
      #(profiles.first.passport_expiry).to_date.should == @date_expiry
      profiles.first.visa_category.should =='H1B'
      #(profiles.first.visa_expiry).to_date.strftime("%d%m%Y").should == (Date.today+3.months).to_date.strftime("%d%m%Y")
      profiles.first.employee_id.should==@profile.employee_id
    end

    it "should return the employees whose name match with the name parameter" do
      Location.should_receive(:get_all_location_ids).and_return([1])
      profile2=ModelFactory.create_profile(:employee_id=>'21223', :common_name=>'aravindu')
      profile2.visas<<ModelFactory.create_visa()
      profile2.passport=ModelFactory.create_passport(:profile_id=>profile2.id)
      profiles=Profile.immigration_advanced_search('', '', 'Mohan', 'H1B', 1, 'paginate')
      profiles.size.should == 1
      profiles.first.common_name.should == "Mohan"
    end

    it "should return the employees whose location match with the location parameter" do
      profile2=ModelFactory.create_profile(:employee_id=>'56789', :common_name=>'prabha p', :location_id => "4")
      profile2.visas<<ModelFactory.create_visa()
      profile2.passport=ModelFactory.create_passport(:profile_id=>profile2.id)
      profiles=Profile.immigration_advanced_search(['4'], '', '', 'H1B', 1, 'paginate')
      profiles.size.should == 1
      profiles.first.location_id.should == 4
      profiles.first.common_name.should == "prabha p"
    end

    it "should return the employees whose role  match with the role parameter" do
      Location.should_receive(:get_all_location_ids).and_return([1])
      profile2=ModelFactory.create_profile(:employee_id=>'56749', :common_name=>'Nivedita S', :title => "Recruiter")
      profile2.visas<<ModelFactory.create_visa()
      profile2.passport=ModelFactory.create_passport(:profile_id=>profile2.id)
      profiles=Profile.immigration_advanced_search('', ['Recruiter'], '', 'H1B', 1, 'paginate')
      profiles.size.should == 1
      profiles.first.location_id.should == 1
      profiles.first.common_name.should == "Nivedita S"
    end
    it "should not return the exit employees" do
      @profile.last_day=Date.today
      @profile.save
      profiles=Profile.immigration_advanced_search('', ['Recruiter'], '', 'H1B', 1, 'paginate')
      profiles.size.should==0
    end
    it "should return an paginated collection when the type is sent as paginate" do
      profiles=Profile.immigration_advanced_search('', ['Recruiter'], '', 'H1B', 1, 'paginate')
      profiles.class.should==WillPaginate::Collection
    end
    it "should return an array when the type is sent as find" do
      profiles=Profile.immigration_advanced_search('', ['Recruiter'], '', 'H1B', 1, 'find')
      profiles.class.should==Array
    end
    it "should not return the profile who dont have any visas when the type of visa is set as any" do
      Location.should_receive(:get_all_location_ids).and_return([1])
      profile2= ModelFactory.create_profile(:employee_id=>'34553')
      profiles=Profile.immigration_advanced_search('', '', '', 'any', 1, 'paginate')
      profiles.size.should==1
    end
  end

  describe "search parameter finder" do
    it "should return the profile which matches the search criteria" do
      profile = ModelFactory.create_profile(:employee_id=>'56749', :common_name=>'Nivedita S', :title => "Recruiter")
      Profile.find_search_parameters("nive").should == [profile]
    end
  end

  describe "get current employees with specific info" do
    before(:each) do
      location = Location.find_by_id(1)
      @profile = ModelFactory.create_profile(attr = {:employee_id => '98989', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772'}, qualification_attrs = {:branch=>"cse", :degree=>'BE'})
      @profile_2 = ModelFactory.create_profile(:employee_id => '98988', :title=>'Developer', :gender=>'Male', :account_no=>'777774', :pan_no=>'777775', :epf_no=>'777776', :last_day => '2011-03-05'.to_datetime)
      @qualification_1 = ModelFactory.create_qualification(:branch=>"cse", :degree=>'BE', :profile=>@profile)
      @passports = ModelFactory.create_passport(:number=>'1983374557', :date_of_issue=>'2010-03-05'.to_datetime, :profile=>@profile)
      @experiences_1 = ModelFactory.create_experience(:technology => 'Ruby', :last_used => '2011-09-24'.to_datetime, :duration=>24, :profile=>@profile)
      @experiences_2 = ModelFactory.create_experience(:technology => 'Ruby', :last_used => '2009-09-24'.to_datetime, :duration=>12, :profile=>@profile)
      @life_insurance_1 = ModelFactory.create_life_insurance_beneficiary(:name=>'name life insurance1', :relationship=>'relationship life insurance1', :percentage=>40, :profile=>@profile)
      @life_insurance_2 = ModelFactory.create_life_insurance_beneficiary(:name=>'name life insurance2', :relationship=>'relationship life insurance2', :percentage=>50, :profile=>@profile)
      @medical_dependent = ModelFactory.create_medical_dependent(:name=>'name medical dependent1', :relationship=>'relationship medical dependent1', :date_of_birth=>'1985-03-05'.to_datetime, :profile=>@profile)
      @medical_dependent_2 = ModelFactory.create_medical_dependent(:name=>'name medical dependent2', :relationship=>'relationship medical dependent2', :date_of_birth=>'1986-03-05'.to_datetime, :profile=>@profile)
    end

    it "should return a hash with all default columns header" do
      report_data = Profile.get_customized_report()
      report_data[:header][0].should == "Employee ID"
      report_data[:header][1].should == "First Name"
      report_data[:header][2].should == "Last Name"
      report_data[:header][3].should == "Home Office"
      report_data[:header].size.should == 4
    end

    it "should return a hash with dynamic column headers customized" do
      report_data = Profile.get_customized_report(
          {'Medical Insurance' => ['Dependent Name', 'Relationship', 'Age', 'DOB'],
           'Life Insurance' => ['Beneficiary Name', 'Relationship with Employee', 'Percentage'],
           'Experience Details' => ['Technology', 'Last Used'],
           'Qualification Details' => ['Degree', 'Branch']})
      report_data[:header][4].should == "Qualification_1_Degree"
      report_data[:header][5].should == "Qualification_1_Branch"
      report_data[:header][6].should == "Qualification_2_Degree"
      report_data[:header][7].should == "Qualification_2_Branch"
      report_data[:header][8].should == "Experience_1_Technology"
      report_data[:header][9].should == "Experience_1_Last Used"
      report_data[:header][10].should == "Experience_2_Technology"
      report_data[:header][11].should == "Experience_2_Last Used"
      report_data[:header][12].should == "Life_Insurance_1_Beneficiary Name"
      report_data[:header][13].should == "Life_Insurance_1_Relationship with Employee"
      report_data[:header][14].should == "Life_Insurance_1_Percentage"
      report_data[:header][15].should == "Life_Insurance_2_Beneficiary Name"
      report_data[:header][16].should == "Life_Insurance_2_Relationship with Employee"
      report_data[:header][17].should == "Life_Insurance_2_Percentage"
      report_data[:header][18].should == "Medical_Insurance_1_Dependent Name"
      report_data[:header][19].should == "Medical_Insurance_1_Relationship"
      report_data[:header][20].should == "Medical_Insurance_1_Age"
      report_data[:header][21].should == "Medical_Insurance_1_DOB"
      report_data[:header][22].should == "Medical_Insurance_2_Dependent Name"
      report_data[:header][23].should == "Medical_Insurance_2_Relationship"
      report_data[:header][24].should == "Medical_Insurance_2_Age"
      report_data[:header][25].should == "Medical_Insurance_2_DOB"
      report_data[:header].size.should == 26
    end

    it "should return a hash with static column headers customized" do
      report_data = Profile.get_customized_report(
          {'Personal Details' => ['Role', 'Gender', 'Email ID'],
           'Financial Information' => ['Bank Account No', 'PAN No'],
           'Passport Details' => ['Passport Number', 'Date of Issue']})
      report_data[:header][4].should == "Role"
      report_data[:header][5].should == "Gender"
      report_data[:header][6].should == "Email ID"
      report_data[:header][7].should == "Passport Number"
      report_data[:header][8].should == "Date of Issue"
      report_data[:header][9].should == "Bank Account No"
      report_data[:header][10].should == "PAN No"
      report_data[:header].size.should == 11
    end

    it "should return a hash with default column data customized" do
      report_data = Profile.get_customized_report()
      report_data[:data][@profile.id]["Employee ID"].should == "98989"
      report_data[:data][@profile.id]["First Name"].should == "Mohan"
      report_data[:data][@profile.id]["Last Name"].should == "S"
      report_data[:data][@profile.id]["Home Office"].should == "Bangalore 1"
      report_data[:data][@profile.id].size.should == 4

    end

    it "should return a hash with personal details column data customized" do
      report_data = Profile.get_customized_report(
          {'Personal Details' => ['Role', 'Gender', 'Email ID']})
      report_data[:data][@profile.id]["Role"].should == "Developer"
      report_data[:data][@profile.id]["Gender"].should == "Male"
      report_data[:data][@profile.id]["Email ID"].should == "nivedis"
      report_data[:data][@profile.id].size.should == 7
    end

    it "should return a hash with passport details columns data customized" do
      report_data = Profile.get_customized_report(
          {'Passport Details' => ['Passport Number', 'Date of Issue']})
      report_data[:data][@profile.id]["Passport Number"].should == "1983374557"
      report_data[:data][@profile.id]["Date of Issue"].should == '2010-03-05'.to_datetime
      report_data[:data][@profile.id].size.should == 6
    end

    it "should return a hash with financial information columns data customized" do
      report_data = Profile.get_customized_report(
          {'Financial Information' => ['Bank Account No', 'PAN No']})
      report_data[:data][@profile.id]["Bank Account No"].should == "777770"
      report_data[:data][@profile.id]["PAN No"].should == '777771'
      report_data[:data][@profile.id].size.should == 6
    end

    it "should return a hash with dynamic qualification columns data customized" do
      report_data = Profile.get_customized_report(
          {'Qualification Details' => ['Degree', 'Branch']})
      report_data[:data][@profile.id]["Qualification_1_Degree"].should == "BE"
      report_data[:data][@profile.id]["Qualification_1_Branch"].should == 'cse'
      report_data[:data][@profile.id]["Qualification_2_Degree"].should == "BE"
      report_data[:data][@profile.id]["Qualification_2_Branch"].should == 'cse'
      report_data[:data][@profile.id].size.should == 8
      end

    it "should return a hash with dynamic qualification in two employee columns data customized" do
      profile = ModelFactory.create_profile(:employee_id => '98909', :title=>'Developer', :gender=>'Male', :account_no=>'777770', :pan_no=>'777771', :epf_no=>'777772')
      ModelFactory.create_qualification(:branch=>"cse", :degree=>'BE', :profile=>profile)
      report_data = Profile.get_customized_report(
          {'Qualification Details' => ['Degree', 'Branch']})
      report_data[:data][@profile.id]["Qualification_1_Degree"].should == "BE"
      report_data[:data][@profile.id]["Qualification_1_Branch"].should == 'cse'
      report_data[:data][@profile.id]["Qualification_2_Degree"].should == "BE"
      report_data[:data][@profile.id]["Qualification_2_Branch"].should == 'cse'
      report_data[:data][profile.id]["Qualification_1_Degree"].should == 'BE'
      report_data[:data][profile.id]["Qualification_1_Branch"].should == 'cse'
      report_data[:data][profile.id]["Qualification_2_Degree"].should == 'BE'
      report_data[:data][profile.id]["Qualification_2_Branch"].should == 'cse'
      report_data[:data][@profile.id].size.should == 8
      report_data[:data][profile.id].size.should == 8
    end

    it "should return a hash with dynamic experience columns data customized" do
      report_data = Profile.get_customized_report(
          {'Experience Details' => ['Technology', 'Last Used', 'Duration(months)']})
      report_data[:data][@profile.id]["Experience_1_Technology"].should == "Ruby"
      report_data[:data][@profile.id]["Experience_1_Last Used"].should == "2011-09-24".to_datetime
      report_data[:data][@profile.id]["Experience_1_Duration(months)"].should == 24
      report_data[:data][@profile.id]["Experience_2_Technology"].should == "Ruby"
      report_data[:data][@profile.id]["Experience_2_Last Used"].should == "2009-09-24".to_datetime
      report_data[:data][@profile.id]["Experience_2_Duration(months)"].should == 12
      report_data[:data][@profile.id].size.should == 10
    end

    it "should return a hash with dynamic medical insurance columns data customized" do
      report_data = Profile.get_customized_report(
          {'Medical Insurance' => ['Dependent Name', 'Relationship', 'Age', 'DOB']})
      report_data[:data][@profile.id]["Medical_Insurance_1_Dependent Name"].should == "name medical dependent1"
      report_data[:data][@profile.id]["Medical_Insurance_1_Relationship"].should == "relationship medical dependent1"
      report_data[:data][@profile.id]["Medical_Insurance_1_Age"].should == 26
      report_data[:data][@profile.id]["Medical_Insurance_1_DOB"].should == '1985-03-05'.to_datetime
      report_data[:data][@profile.id]["Medical_Insurance_2_Dependent Name"].should == "name medical dependent2"
      report_data[:data][@profile.id]["Medical_Insurance_2_Relationship"].should == "relationship medical dependent2"
      report_data[:data][@profile.id]["Medical_Insurance_2_Age"].should == 25
      report_data[:data][@profile.id]["Medical_Insurance_2_DOB"].should == '1986-03-05'.to_datetime
      report_data[:data][@profile.id].size.should == 12
    end

    it "should return a hash with dynamic Life Insurance columns data customized" do
      report_data = Profile.get_customized_report(
          {'Life Insurance' => ['Beneficiary Name', 'Relationship with Employee', 'Percentage']})
      report_data[:data][@profile.id]["Life_Insurance_1_Beneficiary Name"].should == "name life insurance1"
      report_data[:data][@profile.id]["Life_Insurance_1_Relationship with Employee"].should == "relationship life insurance1"
      report_data[:data][@profile.id]["Life_Insurance_1_Percentage"].should == 40
      report_data[:data][@profile.id]["Life_Insurance_2_Beneficiary Name"].should == "name life insurance2"
      report_data[:data][@profile.id]["Life_Insurance_2_Relationship with Employee"].should == "relationship life insurance2"
      report_data[:data][@profile.id]["Life_Insurance_2_Percentage"].should == 50
      report_data[:data][@profile.id].size.should == 10
    end
    
    it "should remove resigned employee in customized " do
      report_data = Profile.get_customized_report()
      report_data[:data].size.should == 1
      report_data[:data].keys.first.should == @profile.id
    end

  end
end


