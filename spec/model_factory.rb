class ModelFactory
  def self.create_profile(attr = {}, qualification_attrs = {})
    valid_attr = {
      :employee_id => "12345",
      :name=>'Mohan',
      :surname=>'S',
      :common_name=>'Mohan',
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
      :temporary_city=>'Chennai',
      :temporary_state=>'tamil nadu',
      :temporary_pincode=>'123456',
      :guardian_name=>'niveditha',
      :location_id=>attr[:location].nil? ? '1':attr[:location].id,
      :date_of_joining=>Time.zone.parse('06/06/2009').to_date,
      :transfer_date=>Time.parse('06/06/2009'),
      :transfer_from=>'1',
      :transfer_to=>'2',
      :date_of_birth=>Time.parse('06/06/2009'),
      :years_of_experience=>250,
      :email_id=>'nivedis',
      :personal_email_id=>'aaa@gmail.com',
      :permanent_phone_number=>"1233445",
      :temporary_phone_number=>"12334354",
      :pan_no=>'123456',
      :emergency_contact_number=>'986568556',
      :emergency_contact_person=>'aafaf',
      :blood_group=>'B+',
      :completed=> 0
    }
    profile=Profile.new(valid_attr.merge(attr))
    profile.qualifications << create_qualification(qualification_attrs)
    profile.save!
    profile
  end

  def self.create_qualification(attr={})
    valid_attr={
      :branch=>"cse",
      :college=>"college",
      :category=>"category1",
      :degree=>'BE'
    }
    Qualification.create(valid_attr.merge(attr))
  end

  def self.create_resource(attr={})
    valid_attributes={
      :Name=>'Name',
      :LevelId=>"LevelID",
      :LocationID=>"LocationID",
      :CurrentLocationID=>"CurrentLocation",
      :DateOfJoining=>Time.parse('06/06/2009').to_date,
      :EmployeeID=>"12345",
      :IsBillable=>true,
      :IsProxy=>false,
      :Notes=>"Notes",
      :ExchangeID=>"ExchangeID",
      :IsSalesLeader=>true,
      :IsSolutionArchitect=>true,
      :IsSponsor=>true
    }
    resource.ResourceID= attr[:ResourceID].blank? ? "ResourceID": attr[:ResourceID]
    resource.save!
    resource
  end

  def self.create_account(attr={})
    valid_attr={
      :Name => "Sears",
      :AccountID => "ACCOUNTID"
    }
    account.AccountID = attr[:AccountID].blank? ? 'ACCOUNTID' : attr[:AccountID]
    account.save!
    account
  end

  def self.create_experience(attr={})
    valid_attr={
      :technology => "Java",
      :duration => "6"
    }
    experience = Experience.new(valid_attr.merge(attr))
    experience.save!
    experience
  end
  def self.create_medical_dependent(attr={})
    valid_attr={
      :name=>"dependent1",
      :relationship=>"Father",
      :date_of_birth=>Date.parse('08/08/1950').to_date
    }
    medical_dependent=Medical.new(valid_attr.merge(attr))
    medical_dependent.save!
    medical_dependent
  end

  def self.create_life_insurance_beneficiary(attr={})
    valid_attr={
      :name=>"beneficiary1",
      :relationship=>"Mother",
      :percentage=>"100"
    }
    life_insurance_beneficiary=Life.new(valid_attr.merge(attr))
    life_insurance_beneficiary.save!
    life_insurance_beneficiary
  end

  def self.create_project_technologies(attr={})
    valid_attr={
      :name=>'javascript'
    }
    a=Project.first
    project_tech=ProjectTechnology.new(valid_attr.merge(attr))
    project_tech.project_id=a.id
    project_tech.save!
    project_tech
  end

  def self.create_visa(attr={})
    valid_attr = {:category => "H1B",:expiry_date=>Time.zone.today+3.months}
    Visa.create!(valid_attr.merge(attr))
  end

  #passport can exist only if it has some profileid
  def self.create_passport(attr={})
    valid_attr = {
      :number=>'PN12345',
      :date_of_issue=>Time.zone.today,
      :date_of_expiry=>Time.zone.today.to_date+10.years,
      :place_of_issue=>'India',
      :nationality=>'India'
    }
    Passport.create!(valid_attr.merge(attr))
  end

  def self.create_location(attr={})
    valid_attributes={
      :name=>'California',
      :countries_id=>'Country',
    }
    #location.LocationID=attr[:LocationID].blank? ? 'CurrentLocation': attr[:LocationID]
    location = Location.create!(valid_attributes.merge(attr))
    location
  end

  def self.create_dependent_passport(attr={})
    valid_attr = {
      :number=>'PN12345',
      :date_of_issue=>Time.zone.today,
      :date_of_expiry=>Time.zone.today.to_date+10.years,
      :place_of_issue=>'India',
      :nationality=>'India',
      :name=>'Mohan',
      :relationship=>'mother'
    }
    dependent_passport=DependentPassport.create!(valid_attr.merge(attr))
    dependent_passport
  end

  def self.create_checklist_group(attr={})
    valid_attr = {
      :order => 1,
      :description => "description"
    }
    checklist_group=ChecklistGroup.create!(valid_attr.merge(attr))
    checklist_group
  end


  def self.create_checklist(attr={})
    valid_attr = {
      :description => 'description',
      :group_id => create_checklist_group.id,
      :checklist_id => 1
    }
    checklist = NewJoineeChecklist.create!(valid_attr.merge(attr))
    checklist
  end

  def self.create_employee_checklist_submitted(attr={})

    valid_attr = {
      :profile_id => Factory.create(:profile).id,
      :new_joinee_checklists_id => create_checklist.id
    }
    employeeChecklistSubmitted = EmployeeChecklistSubmitted.create!(valid_attr.merge(attr))
    employeeChecklistSubmitted
  end

  def self.create_titles(attr={})
    valid_attr = {
      :name => "name"
    }
    titles = Title.create!(valid_attr.merge(attr))
    titles
  end

  def self.create_categories(attr={})
    valid_attr = {
      :category => "category",
      :name => "name"
    }
    degrees = Degree.create!(valid_attr.merge(attr))
    degrees
  end

  def self.create_locations(attr={})
    valid_attr = {
      :name => "name",
      :countries_id => 1
    }
    locations = Location.create!(valid_attr.merge(attr))
    locations
  end

  def self.create_admin(attr={})
    valid_attr = {
      :username => "name",
      :role => "admin"
    }
    admins = User.create!(valid_attr.merge(attr))
    admins
  end

  def self.create_attached_document(attr={})
    valid_attr = {
      :name => "David's Passport",
      :document_type => "Passport",
      :document_file_name => "image",
      :document_content_type => "image/png"
    }
    AttachedDocument.create!(valid_attr.merge(attr))
  end
end
