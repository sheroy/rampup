require 'spreadsheet'
#require 'rubygems'
module Exporter
  module ExcelExporter
    def export(path, type)
      workbook=create_excel
      worksheet1 = workbook.create_worksheet :name=>'Profiles'
      worksheet2 = workbook.create_worksheet :name=>'Qualifications'
      worksheet3 = workbook.create_worksheet :name=>'Experience'
      worksheet4 = workbook.create_worksheet :name=>'Passport'
      worksheet5 = workbook.create_worksheet :name=>'Life Insurance'
      worksheet6 = workbook.create_worksheet :name=>'Medical Insurance'
      worksheet7 = workbook.create_worksheet :name=>'Financial Details'
      add_profile_headers(worksheet1)
      add_qualification_headers(worksheet2)
      add_passport_headers(worksheet4)
      add_financial_details_headers(worksheet7)
      add_experience_headers(worksheet3)
      add_life_insurance_headers(worksheet5)
      add_medical_insurance_headers(worksheet6)
      add_data(worksheet1,worksheet2,worksheet3,worksheet4,worksheet5,worksheet6,worksheet7,type)
      workbook.write path
    end

    def create_excel
      Spreadsheet.client_encoding = "LATIN1//TRANSLIT//IGNORE"
      workbook = Spreadsheet::Workbook.new
      workbook
    end

    def add_passport_headers(worksheet4)
      worksheet4[0,0]="PSID"
      worksheet4[0,1]="CommonName"
      worksheet4[0,2]="Passport Number"
      worksheet4[0,3]="Date of Issue"
      worksheet4[0,4]="Date of Expiry"
      worksheet4[0,5]="Place of Issue"
      worksheet4[0,6]="Nationality"
    end

    def add_financial_details_headers(worksheet7)
      worksheet7[0,0]="PSID"
      worksheet7[0,1]="CommonName"
      worksheet7[0,2]="Account Number"
      worksheet7[0,3]="PAN Number"
      worksheet7[0,4]="EPF Number"
    end

    def add_profile_headers(worksheet1)
      worksheet1[0,0]="PSID"
      worksheet1[0,1]="SurName"
      worksheet1[0,2]="GivenName"
      worksheet1[0,3]="CommonName"
      worksheet1[0,4]="Role"
      worksheet1[0,5]="FirstDay"
      worksheet1[0,6]="BirthDate"
      worksheet1[0,7]="M/F"
      worksheet1[0,8]="MaritalStatus"
      worksheet1[0,9]="LastDay"
      worksheet1[0,10]="TransferredTo"
      worksheet1[0,11]="GuardianName"
      worksheet1[0,12]="FirstAddressLine"
      worksheet1[0,13]="SecondAddressine"
      worksheet1[0,14]="ThirdAddressLine"
      worksheet1[0,15]="City"
      worksheet1[0,16]="State"
      worksheet1[0,17]="Pincode"
      worksheet1[0,18]="Location"
      worksheet1[0,19]="TransferredTo"
      worksheet1[0,20]="TransferredDate"
    end

    def add_experience_headers(worksheet3)
      worksheet3[0,0]="PSID"
      worksheet3[0,1]="CommonName"
      worksheet3[0,2]='Java'
      worksheet3[0,3]='Last Used'
      worksheet3[0,4]='.Net'
      worksheet3[0,5]='Last Used'
      worksheet3[0,6]='Ruby'
      worksheet3[0,7]='Last Used'
      worksheet3[0,8]='Other Technology'
    end


    def add_qualification_headers(worksheet2)
      worksheet2[0,0]="PSID"
      worksheet2[0,1]="CommonName"
      worksheet2[0,2]="Prior to TWI"
      worksheet2[0,3]="In TWI"
      worksheet2[0,4]="Total"
    end

    def add_life_insurance_headers(worksheet5)
      i=0
      worksheet5[0,0]="PSID"
      worksheet5[0,1]="CommonName"
      index=1
      2.times do
        worksheet5[0,i+2]="Beneficiary-#{index}"
        worksheet5[0,i+3]="Relationship"
        worksheet5[0,i+4]="Percentage"
        index+=1
        i=i+3
      end
    end

    def add_medical_insurance_headers(worksheet6)
      i=0
      worksheet6[0,0]="PSID"
      worksheet6[0,1]="CommonName"
      index=1
      5.times do
        worksheet6[0,i+2]="Dependent-#{index}"
        worksheet6[0,i+3]="Relationship"
        worksheet6[0,i+4]="Date Of Birth"
        worksheet6[0,i+5]="Age"
        i=i+4
        index+=1
      end
    end


    def add_data(worksheet1,worksheet2,worksheet3,worksheet4,worksheet5,worksheet6,worksheet7,type)
      if type=="Complete"
      @profiles=Profile.all(:conditions=>{:completed=>true, :last_day=>nil})
    elsif type=="Incomplete"
      @profiles=Profile.all(:conditions=>{:completed=>false,:last_day=>nil})
    elsif type=="Both Complete & Incomplete"
      @profiles=Profile.all(:conditions=>['last_day is NULL and employee_id is not NULL and completed is not NULL'])
    elsif type=="Ex-TWers"
      @profiles=Profile.all(:conditions=>["last_day is not NULL"])
    end
      i=1
      @profiles.each do |profile|
        qualifications=profile.qualifications
        #qualification2=profile.qualifications.find(:all,:order=>'graduation_year DESC')[1]
        worksheet1[i,0]=profile.employee_id
        worksheet1[i,1]=profile.surname
        worksheet1[i,2]=profile.name
        worksheet1[i,3]=profile.common_name
        worksheet1[i,4]=profile.title
        worksheet1[i,5]=Calculation::ExperienceCalculation.custom_date_with_month(profile.date_of_joining.to_date) unless profile.date_of_joining.nil?
        worksheet1[i,6]=Calculation::ExperienceCalculation.custom_date_with_month(profile.date_of_birth.to_date) unless profile.date_of_birth.nil?
        if profile.gender == "Male"
          worksheet1[i,7] = "M"
        elsif profile.gender == "Female"
          worksheet1[i,7] = "F"
        else
          worksheet1[i,7] = "O"
        end
        
        if profile.marital_status == "Single"
          worksheet1[i,8] = "S"
        elsif profile.marital_status == "Married"
          worksheet1[i,8] = "M"
        else
          worksheet1[i,8] = "O"
        end

        worksheet1[i,9]=Calculation::ExperienceCalculation.custom_date_with_month(profile.last_day.to_date) unless profile.last_day.nil?
        worksheet1[i,10]=profile.transferred_abroad
        worksheet1[i,11]=profile.guardian_name
        worksheet1[i,12]=profile.temporary_address_line1
        worksheet1[i,13]=profile.temporary_address_line2
        worksheet1[i,14]=profile.temporary_address_line3
        worksheet1[i,15]=profile.temporary_city
        worksheet1[i,16]=profile.temporary_state
        worksheet1[i,17]=profile.temporary_pincode
        worksheet1[i,18]=Location.get_location_name_by_id(profile.location_id)
        worksheet1[i,19]=profile.transfer_to
        worksheet1[i,20]=Calculation::ExperienceCalculation.custom_date_with_month(profile.transfer_date.to_date) unless profile.transfer_date.nil?

        worksheet2[i,0]=profile.employee_id
        worksheet2[i,1]=profile.common_name
        worksheet2[i,2] = Calculation::ExperienceCalculation.experience_outside_tw(profile.years_of_experience) unless profile.years_of_experience.nil?
        worksheet2[i,3] = Calculation::ExperienceCalculation.experience_in_tw(profile.date_of_joining) unless profile.date_of_joining.nil?
        worksheet2[i,4] = Calculation::ExperienceCalculation.total_experience(profile.years_of_experience,profile.date_of_joining)

        qualifications.each_with_index do |qualification,index|
          add_degree_headers(worksheet2,5+(index*5))
          worksheet2[i,5+(index*5)]=qualification.category
          worksheet2[i,6+(index*5)]=qualification.degree
          worksheet2[i,7+(index*5)]=qualification.branch
          worksheet2[i,8+(index*5)]=qualification.college
          worksheet2[i,9+(index*5)]=qualification.graduation_year.to_s unless qualification.graduation_year.nil?
        end

        add_passport_data(worksheet4,profile,i)
        add_financial_data(worksheet7,profile,i)
        add_experience_data(worksheet3,profile,i)
        add_life_insurance_data(worksheet5,profile,i)
        add_medical_insurance_data(worksheet6,profile,i)
        i=i+1
      end
    end
    def add_degree_headers(worksheet2,index)
      worksheet2[0,index] = "Category"
      worksheet2[0,index+1] = "Degree"
      worksheet2[0,index+2] = "Branch"
      worksheet2[0,index+3] = "University"
      worksheet2[0,index+4] = "Graduation Year"
    end

    def add_passport_data(worksheet4,profile,index)
      passport=profile.passport
      worksheet4[index,0] = profile.employee_id
      worksheet4[index,1] = profile.common_name
      if passport.present?
      worksheet4[index,2] = passport.number
      worksheet4[index,3] = passport.date_of_issue.to_date unless passport.date_of_issue.nil?
      worksheet4[index,4] = passport.date_of_expiry.to_date unless passport.date_of_expiry.nil?
      worksheet4[index,5] = passport.place_of_issue
      worksheet4[index,6] = passport.nationality
      end
    end

    def add_life_insurance_data(worksheet5,profile,index)
      lives=profile.lives
      worksheet5[index,0] = profile.employee_id
      worksheet5[index,1] = profile.common_name
      unless lives.size==0
      lives.each_with_index do |life,i|
        worksheet5[index,(i*3)+2] = life.name
        worksheet5[index,(i*3)+3] = life.relationship
        worksheet5[index,(i*3)+4] = life.percentage
      end
      end
    end

    def add_medical_insurance_data(worksheet6,profile,index)
      medicals=profile.medicals
      worksheet6[index,0] = profile.employee_id
      worksheet6[index,1] = profile.common_name
      unless medicals.size==0
      medicals.each_with_index do |medical,i|
        worksheet6[index,(i*4)+2] = medical.name
        worksheet6[index,(i*4)+3] = medical.relationship
        worksheet6[index,(i*4)+4] = medical.date_of_birth.to_date unless medical.date_of_birth.nil?
        worksheet6[index,(i*4)+5] = medical.age
      end
      end
    end
    
    def add_financial_data(worksheet7,profile,index)
      worksheet7[index,0] = profile.employee_id
      worksheet7[index,1] = profile.common_name
      worksheet7[index,2] = profile.account_no.to_i unless profile.account_no.nil?
      worksheet7[index,3] = profile.pan_no
      worksheet7[index,4] = profile.epf_no
    end

    def add_experience_data(worksheet3,profile,index)
      worksheet3[index,0] = profile.employee_id
      worksheet3[index,1] = profile.common_name
      technologies=["java",'.net','ruby']
      technologies.each_with_index do |technology,i|
        experience=profile.get_total_experience_duration_by_name(technology, profile.id)
        worksheet3[index,(i*2)+2]=experience.first.duration.to_s if experience.present?
        worksheet3[index,(i*2)+3]=experience.first.last_used.to_s if experience.present?
      end

      experience = profile.get_other_technologies_experience_by_profile_id(profile.id)
      other_technologies=''
      experience.each_with_index do |row, i|
        if i != 0
          other_technologies = other_technologies + ' |'+$/
        end
        other_technologies = other_technologies + row.technology.to_s + ' ~ ' + row.duration.to_s  + ' ~ ' + row.last_used.to_s 
      end
      worksheet3[index,8]=other_technologies
    end
    module_function :export,:create_excel,:add_profile_headers,:add_qualification_headers,:add_data,:add_passport_headers,
      :add_financial_details_headers,:add_passport_data,:add_financial_data,:add_experience_data,:add_experience_headers,
      :add_life_insurance_headers,:add_medical_insurance_headers,:add_life_insurance_data,:add_medical_insurance_data,:add_degree_headers
  end
end