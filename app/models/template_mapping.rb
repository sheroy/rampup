class TemplateMapping < ActiveRecord::Base
 
  ['RAMPUP_USERNAME', 'RAMPUP_PANNO', 'RAMPUP_DOJ', 'RAMPUP_PERMANENT_ADDRESS', 'RAMPUP_PHONE_NUMBER','RAMPUP_TEMPORARY_ADDRESS','RAMPUP_CELL_PHONE','RAMPUP_LANDLINE',
   'RAMPUP_PERSONAL_EMAIL_ID','RAMPUP_YEARS_OF_EXPERIENCE','RAMPUP_GENDER','RAMPUP_GUARDIAN_NAME','RAMPUP_MARITAL_STATUS','RAMPUP_BLOOD_GROUP',
   'RAMPUP_EMERGENCY_CONTACT','RAMPUP_EMERGENCY_CONTACT_NUMBER','RAMPUP_ACCOUNT_NUMBER', 'RAMPUP_DOB','RAMPUP_PASSPORT_NUMBER',
   'RAMPUP_PASSPORT_DOI','RAMPUP_PASSPORT_PLACE_OF_ISSUE','RAMPUP_PASSPORT_DOE','RAMPUP_BENEFICIARY_NAME','RAMPUP_BENEFICIARY_RELATIONSHIP',
   'RAMPUP_BENEFICIARY_PERCENTAGE', 'RAMPUP_EMPLOYEE_ID', 'RAMPUP_LOCATION', 'RAMPUP_DEPENDENT_AGE', 'RAMPUP_DEPENDENT_NAME', 'RAMPUP_DEPENDENT_RELATIONSHIP',
    'RAMPUP_DEPENDENT_DOB','RAMPUP_AGE','RAMPUP_TITLE','RAMPUP_QUALIFICATION','RAMPUP_SPOUSE_NAME',"RAMPUP_SALUTATION","RAMPUP_TEMPORARY_LINE_1",
    "RAMPUP_TEMPORARY_LINE_2","RAMPUP_TEMPORARY_LINE_3","RAMPUP_CITY","RAMPUP_STATE","RAMPUP_PIN","RAMPUP_BRANCH, RAMPUP_SIGNATURE"].each do |val|
    class_eval do
      define_method(name) do
        attributes[name]
      end
    end
  end

  
  def self.get_profile_data(profile_id)
    TemplateMapping.find_by_sql([
      "select common_name as RAMPUP_USERNAME,case when gender='Male' then 'Mr.' else 'Ms.' end as RAMPUP_SALUTATION,
      case when gender='Male' then 'S/O' else 'D/O' end as RAMPUP_RELATIONSHIP,
      pan_no as RAMPUP_PANNO, coalesce(cast(date_of_joining AS DATE) ,'') as RAMPUP_DOJ,
      concat_ws(',',permanent_address_line_1,permanent_address_line2,permanent_Address_line3,permanent_city,permanent_state,permanent_pincode) as RAMPUP_PERMANENT_ADDRESS,
      temporary_phone_number as RAMPUP_PHONE_NUMBER,
      coalesce(temporary_address_line1,'') as RAMPUP_TEMPORARY_LINE_1,
      coalesce(temporary_address_line2,'') as RAMPUP_TEMPORARY_LINE_2,
      coalesce(temporary_address_line3,'') as RAMPUP_TEMPORARY_LINE_3,
      coalesce(temporary_city,'') as RAMPUP_CITY,
      coalesce(temporary_state,'') as RAMPUP_STATE,
      coalesce(temporary_pincode,'') as RAMPUP_PIN,
      concat_ws(',',temporary_address_line1,temporary_address_line2,temporary_address_line3,temporary_city,temporary_state,temporary_pincode) as RAMPUP_TEMPORARY_ADDRESS,
      coalesce(temporary_phone_number,'') as RAMPUP_CELL_PHONE,
      coalesce(permanent_phone_number,'') as RAMPUP_LANDLINE,
      coalesce(personal_email_id,'') as RAMPUP_PERSONAL_EMAIL_ID,
      coalesce(round(years_of_experience/12.0,1),0) as RAMPUP_YEARS_OF_EXPERIENCE,
      coalesce(gender,'') as RAMPUP_GENDER,
      coalesce(guardian_name,'') as RAMPUP_GUARDIAN_NAME,
      coalesce(marital_status,'') as RAMPUP_MARITAL_STATUS,
      coalesce(blood_group,'') as RAMPUP_BLOOD_GROUP,
      coalesce(emergency_contact_person,'') as RAMPUP_EMERGENCY_CONTACT,
      coalesce(emergency_contact_number,'') as RAMPUP_EMERGENCY_CONTACT_NUMBER,
      coalesce(account_no,'') as RAMPUP_ACCOUNT_NUMBER,
      coalesce(epf_no,'') as RAMPUP_EPF_NUMBER,
      coalesce(cast(date_of_birth AS DATE), '') as RAMPUP_DOB,
      coalesce(number,'') as RAMPUP_PASSPORT_NUMBER,
      coalesce(cast(date_of_issue AS DATE),'') as RAMPUP_PASSPORT_DOI,
      coalesce(place_of_issue,'') as RAMPUP_PASSPORT_PLACE_OF_ISSUE,
      coalesce(cast(date_of_expiry AS DATE),'') as RAMPUP_PASSPORT_DOE,
      title as RAMPUP_TITLE,
      employee_id as RAMPUP_EMPLOYEE_ID,
      locations.name as RAMPUP_LOCATION,
      datediff(curdate(), profiles.date_of_birth) DIV 365 as RAMPUP_AGE
      from profiles
      left join passports on profiles.id = passports.profile_id
      left join locations on profiles.location_id = locations.id
      where profiles.id = ?", profile_id])
  end

  def self.get_qualification_data(profile_id)
    TemplateMapping.find_by_sql(["select degree as RAMPUP_QUALIFICATION,branch as RAMPUP_BRANCH from qualifications
                                  where profile_id = ?", profile_id])
    
  end

  def self.get_beneficiary_info_for_life_insurance(profile_id)
    TemplateMapping.find_by_sql(["select dependents.name as RAMPUP_BENEFICIARY_NAME,relationship as RAMPUP_BENEFICIARY_RELATIONSHIP, percentage as RAMPUP_BENEFICIARY_PERCENTAGE,
                                common_name as RAMPUP_USERNAME,employee_id as RAMPUP_EMPLOYEE_ID from dependents
                                JOIN profiles on profiles.id=dependents.profile_id
                                where dependents.type='life' and profile_id=?",profile_id])
  end

  def self.get_beneficiary_info_for_medical_insurance(profile_id)
    TemplateMapping.find_by_sql(["select dependents.name as RAMPUP_DEPENDENT_NAME,relationship as RAMPUP_DEPENDENT_RELATIONSHIP,
                                cast(dependents.date_of_birth AS DATE) as RAMPUP_DEPENDENT_DOB, common_name as RAMPUP_USERNAME,employee_id as RAMPUP_EMPLOYEE_ID,
                                title as RAMPUP_TITLE,
                                locations.name as RAMPUP_LOCATION, datediff(curdate(), dependents.date_of_birth) DIV 365 as RAMPUP_DEPENDENT_AGE,
                                cast(profiles.date_of_birth AS DATE) as RAMPUP_DOB, datediff(curdate(), profiles.date_of_birth) DIV 365 as RAMPUP_AGE
                                FROM dependents
                                JOIN profiles on profiles.id=dependents.profile_id
                                left join locations on profiles.location_id = locations.id
                                where dependents.type='medical' and profile_id=?",profile_id])
  end


  def self.get_spouse_name(profile_id)
    TemplateMapping.find_by_sql(["select coalesce(name,'') as RAMPUP_SPOUSE_NAME from dependents where relationship in ('Spouse','Husband','Wife') and profile_id = ?",profile_id])
  end

  def self.get_signature(name)
    TemplateMapping.find_by_sql(["select signatures.signature as RAMPUP_SIGNATURE
                               FROM signatures
                               where signatures.name=?",name])
  end
end
