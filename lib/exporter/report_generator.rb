require 'spreadsheet'
module Exporter
  module ReportGenerator
    SUBMITTED =" "
    NOT_SUBMITTED="Not Submitted"

    def custom_report_export(path, customized_report_data)
      workbook=create_excel
      set_data_for_customized_report(workbook.create_worksheet(:name=>'Customized Report'),
                                     customized_report_data)
      workbook.write path
    end

    def set_data_for_customized_report(worksheet, customized_report_data)
      customized_report_data[:header].each_with_index do |item, index|
        worksheet[0, index] = item
      end
      customized_report_data[:data].values.each_with_index do |content, index|
        content.each do |key, value|
          position = customized_report_data[:header].index(key)
            worksheet[index + 1, position] = value.nil? ? '' : value
        end
      end
    end

    def no_passport_export(path, profiles)
      workbook=create_excel
      worksheet=workbook.create_worksheet :name=>'Profiles'
      add_no_passport_profiles_header(worksheet)
      add_no_passport_profiles_data(worksheet, profiles)
      workbook.write path
    end

    def create_checklist_report(path)
      workbook= create_excel
      worksheet=workbook.create_worksheet :name=>"checklist_report"
      profiles=Profile.all
      create_mandatory_headers(worksheet)
      create_optional_headers(worksheet)
      add_checklist_mandatory_data(worksheet, profiles)
      add_checklist_optional_data(worksheet, profiles)
      workbook.write path
    end

    def create_mandatory_headers(worksheet)
      worksheet.row(0)[0]="ID"
      worksheet.row(0)[1]="First Name"
      worksheet.row(0)[2]="Last Name"
      worksheet.row(0)[3]="Home Office"
    end

    def create_optional_headers(worksheet)
      col_num=4
      new_joinees = NewJoineeChecklist.all
      new_joinees.each do |checklist|
         worksheet.row(0)[col_num]=checklist.report_column_name
         checklist.report_column_name
         col_num=col_num+1
      end
    end

    def add_checklist_mandatory_data(worksheet, profiles)
      (0..profiles.size-1).each do |i|
        worksheet.row(i+1)[0]=profiles[i].employee_id
        worksheet.row(i+1)[1]=profiles[i].name
        worksheet.row(i+1)[2]=profiles[i].surname
        worksheet.row(i+1)[3]=Location.get_location_name_by_id(profiles[i].location_id)
      end
    end

    def add_checklist_optional_data(worksheet, profiles)
      profiles.each_index { |profile_index|
        row_number = profile_index + 1
        checklists = profiles[profile_index].employee_checklist_submitteds
        (0..checklists.size-1).each do |i|

          key = NewJoineeChecklist.find_by_id(checklists[i].new_joinee_checklists_id).checklist_id
          worksheet[row_number, key+3]=SUBMITTED

        end
        (4..worksheet.row(0).size-1).each do |i|
          if (worksheet[row_number, i].nil?)
            worksheet[row_number, i]=NOT_SUBMITTED
          end
        end
      }
      worksheet
    end


    def add_no_passport_profiles_header(worksheet)
      worksheet[0, 0]="Employee ID"
      worksheet[0, 1]="Name"
      worksheet[0, 2]="Home Office"
      worksheet[0, 3]="Mail ID"
    end

    def add_no_passport_profiles_data(worksheet, profiles)
      index=1
      profiles.each do |profile|
        worksheet[index, 0]=profile.employee_id
        worksheet[index, 1]=profile.common_name
        worksheet[index, 2]=Location.get_location_name_by_id(profile.location_id)
        worksheet[index, 3]=profile.email_id
        index+=1
      end
    end

    def create_empty_excel
      workbook = create_excel
      workbook.create_worksheet
      workbook
    end

    def birthday_babies_export(path, profiles)
      unless profiles.empty? or profiles.flatten.empty?
        workbook = create_excel
        profiles.each do |profile|
          next if profile.first.blank?
          worksheet=workbook.create_worksheet :name=>Location.find(profile.first.location_id).name
          add_birthday_babies_header(worksheet)
          add_birthday_babies_data(worksheet, profile)
        end
      else
        workbook = create_empty_excel
      end
      workbook.write path
    end

    def add_birthday_babies_header(worksheet)
      worksheet[0, 0]="Employee ID"
      worksheet[0, 1]="Name"
      worksheet[0, 2]="Birthday"
    end

    def add_birthday_babies_data(worksheet, profiles)
      index=1
      profiles.each do |profile|
        worksheet[index, 0]=profile.employee_id
        worksheet[index, 1]=profile.common_name
        worksheet[index, 2]=profile.date_of_birth.to_date.strftime("%d - %B")
        index+=1
      end
    end

    def passport_expiry_profiles_export(path, profiles)
      workbook=create_excel
      worksheet=workbook.create_worksheet :name=>'Profiles'
      add_passport_expiry_profiles_header(worksheet)
      add_passport_expiry_profiles_data(worksheet, profiles)
      workbook.write path
    end

    def add_passport_expiry_profiles_header(worksheet)
      worksheet[0, 0]="Employee ID"
      worksheet[0, 1]="Name"
      worksheet[0, 2]="Home Office"
      worksheet[0, 3]="Mail ID"
      worksheet[0, 4]="Date of Expiry"
    end

    def add_passport_expiry_profiles_data(worksheet, profiles)
      index=1
      profiles.each do |profile|
        worksheet[index, 0]=profile.employee_id
        worksheet[index, 1]=profile.common_name
        worksheet[index, 2]=Location.get_location_name_by_id(profile.location_id)
        worksheet[index, 3]=profile.email_id
        worksheet[index, 4]=profile.passport.date_of_expiry.to_date if profile.passport
        index+=1
      end
    end

    def medical_insurance_export(path, column_name, field_name, profiles)
      workbook=create_excel
      worksheet=workbook.create_worksheet :name=>'medical'
      add_medical_insurance_headers(worksheet, column_name)
      add_medical_insurance_data(worksheet, field_name, profiles)
      workbook.write path
    end

    def life_insurance_export(path, column_name, field_name, profiles)
      workbook=create_excel
      worksheet=workbook.create_worksheet :name=>'life'
      add_life_insurance_headers(worksheet, column_name)
      add_life_insurance_data(worksheet, field_name, profiles)
      workbook.write path
    end

    def create_excel
      Spreadsheet.client_encoding = "LATIN1//TRANSLIT//IGNORE"
      workbook = Spreadsheet::Workbook.new
      workbook
    end

    def add_medical_insurance_headers(worksheet, column_name)
      i=0
      worksheet[0, 0]="PSID"
      worksheet[0, 1]="CommonName"
      worksheet[0, 2]=column_name
      index=1
      5.times do
        worksheet[0, i+3]="Dependent-#{index}"
        worksheet[0, i+4]="Relationship"
        worksheet[0, i+5]="Date Of Birth"
        worksheet[0, i+6]="Age"
        i=i+4
        index+=1
      end
    end

    def add_life_insurance_headers(worksheet, column_name)
      i=0
      worksheet[0, 0]="PSID"
      worksheet[0, 1]="CommonName"
      worksheet[0, 2]=column_name
      index=1
      2.times do
        worksheet[0, i+3]="Beneficiary-#{index}"
        worksheet[0, i+4]="Relationship"
        worksheet[0, i+5]="Percentage"
        index+=1
        i=i+3
      end
    end

    def add_life_insurance_data(worksheet, field_name, profiles)
      profiles.each_with_index do |profile, j|
        index=j+1
        lives=profile.lives
        worksheet[index, 0] = profile.employee_id
        worksheet[index, 1] = profile.common_name
        worksheet[index, 2] = profile.send(field_name).to_date
        unless lives.size==0
          lives.each_with_index do |life, i|
            worksheet[index, (i*3)+3] = life.name
            worksheet[index, (i*3)+4] = life.relationship
            worksheet[index, (i*3)+5] = life.percentage
          end
        end
      end
    end

    def add_medical_insurance_data(worksheet, field_name, profiles)
      profiles.each_with_index do |profile, j|
        index=j+1 #the first row ll be the column headers
        medicals=profile.medicals
        worksheet[index, 0] = profile.employee_id
        worksheet[index, 1] = profile.common_name
        worksheet[index, 2] = profile.send(field_name).to_date
        unless medicals.size==0
          medicals.each_with_index do |medical, i|
            worksheet[index, (i*4)+3] = medical.name
            worksheet[index, (i*4)+4] = medical.relationship
            worksheet[index, (i*4)+5] = medical.date_of_birth.to_date unless medical.date_of_birth.nil?
            worksheet[index, (i*4)+6] = medical.age
          end
        end
      end
    end

    module_function :custom_report_export,:set_data_for_customized_report ,:medical_insurance_export, :create_excel, :add_medical_insurance_headers, :add_medical_insurance_data, :life_insurance_export, :add_life_insurance_headers, :add_life_insurance_data, :no_passport_export, :add_no_passport_profiles_header, :add_no_passport_profiles_data,
                    :passport_expiry_profiles_export, :add_passport_expiry_profiles_header, :add_passport_expiry_profiles_data, :birthday_babies_export, :add_birthday_babies_header, :add_birthday_babies_data, :create_mandatory_headers, :create_optional_headers, :add_checklist_mandatory_data, :add_checklist_optional_data, :create_checklist_report, :create_empty_excel
  end
end
