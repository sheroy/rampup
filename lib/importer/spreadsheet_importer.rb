require 'spreadsheet'

module Importer
  module SpreadsheetImporter

    def import(path, emp_id, email_id)
      excel_book = open_spreadsheet(path)
      begin
        profile = new_profile_type excel_book
        profile.employee_id= emp_id
        profile.email_id= email_id
        profile = map_spreadsheet_to_profile excel_book, profile
        profile.save(:validate => false)
        return profile
      rescue => e
        Rails.logger.info e.message
      end
    end


    def open_spreadsheet(path)
      Spreadsheet.client_encoding = "UTF-8//TRANSLIT//IGNORE"
      Spreadsheet.open(path)
    end


    def self.map_spreadsheet_to_profile(excel_book, profile)
      profile = map_personal_details profile, excel_book
      profile = map_financial_details profile, excel_book
      profile = map_passport_details profile, excel_book
      profile = map_experience_details profile, excel_book
      profile = map_qualification_details profile, excel_book
      index = map_life_dependent_details profile, excel_book
      profile= map_medical_dependent_details profile, excel_book, index
      profile
    end

    private
    def new_profile_type excel_book
      sheet = excel_book.worksheet 0
      profile_type = safe_copy_string_value_from_sheet(sheet[7, 1])
      if profile_type.strip == "ETG"
        return Etg.new
      elsif profile_type.strip == "Support"
        return Support.new
      end
      ProfessionalServices.new
    end

    def map_personal_details(profile, excel_book)
      sheet = excel_book.worksheet 0
      profile.name = safe_copy_string_value_from_sheet(sheet[8, 1])
      profile.surname = safe_copy_string_value_from_sheet(sheet[9, 1])
      profile.common_name = profile.name + profile.surname
      profile.title = sheet[11, 1]
      profile.gender = sheet[12, 1]
      profile.marital_status = sheet[13, 1]
      profile.date_of_birth = safe_copy_date_value_from_sheet(sheet[14, 1])
      profile.personal_email_id = sheet[15, 1]
      profile.guardian_name = sheet[16, 1]
      (sheet[17, 1].blank?) ? (profile.date_of_joining=Time.zone.today) : (profile.date_of_joining=sheet[17, 1].to_s.to_date)
      profile.years_of_experience = safe_copy_integer_value_from_sheet(sheet[18, 1])
      (sheet[19, 1].blank?) ? (profile.location_id=nil) : (profile.location_id=Location.find_by_name(sheet[19, 1]).id)
      profile.temporary_address_line1 = sheet[22, 1]
      profile.temporary_city = sheet[23, 1]
      profile.temporary_state = sheet[24, 1]
      profile.temporary_pincode = safe_copy_string_value_from_sheet(sheet[25, 1])
      profile.temporary_phone_number = safe_copy_integer_value_from_sheet(sheet[26, 1])
      profile.permanent_address_line_1 = sheet[28, 1]
      profile.permanent_city = sheet[29, 1]
      profile.permanent_state = sheet[30, 1]
      profile.permanent_pincode = safe_copy_string_value_from_sheet(sheet[31, 1])
      profile.permanent_phone_number = safe_copy_integer_value_from_sheet(sheet[32, 1])
      profile.blood_group = sheet[34, 1]
      profile.emergency_contact_person = sheet[35, 1]
      profile.emergency_contact_number = safe_copy_integer_value_from_sheet(sheet[36, 1])
      return profile
    end

    def map_passport_details(profile, excel_book)
      sheet = excel_book.worksheet 3
      profile.save(:validate => false)
      passport = Passport.new
      passport.number = safe_copy_string_value_from_sheet(sheet[3, 1])
      passport.date_of_issue = safe_copy_date_value_from_sheet(sheet[4, 1])
      passport.date_of_expiry = safe_copy_date_value_from_sheet(sheet[5, 1])
      passport.place_of_issue = sheet[6, 1]
      passport.nationality = sheet[7, 1]
      if !(passport.number.blank?)
        passport.profile_id = profile.id
        passport.save(:validate => false)
      end
      profile
    end

    def map_experience_details (profile, excel_book)
      sheet = excel_book.worksheet 2
      index=4
      while !(sheet[index, 0].nil?) do
        experience = Experience.new
        experience.technology = sheet[index, 0]
        experience.last_used = safe_copy_date_value_from_sheet(sheet[index, 1])
        experience.duration = safe_copy_integer_value_from_sheet(sheet[index, 2])
        profile.experiences << experience
        index+=1
      end
      profile
    end

    def map_qualification_details (profile, excel_book)
      sheet = excel_book.worksheet 1
      index = 4
      while !(sheet[index, 1].nil?) do
        qualification = Qualification.new
        qualification.category = sheet[index, 1]
        qualification.degree = sheet[index+1, 1]
        qualification.branch = sheet[index+2, 1]
        qualification.college = sheet[index+3, 1]
        qualification.graduation_year = safe_copy_integer_value_from_sheet(sheet[index+4, 1])
        profile.qualifications << qualification
        index+=6
      end
      profile
    end

    def map_life_dependent_details (profile, excel_book)
      sheet = excel_book.worksheet 4
      index = 5
      while !(sheet[index, 0].nil?) do
        life = Life.new
        life.name = sheet[index, 0]
        life.relationship = sheet[index, 1]
        life.percentage = safe_copy_integer_value_from_sheet(sheet[index, 2])
        profile.dependents << life
        index+=1
      end
      index
    end

    def map_medical_dependent_details (profile, excel_book, index)
      sheet = excel_book.worksheet 4
      while (sheet[index, 0].nil?) do
        index+=1
      end
      index+=1
      while !(sheet[index, 0].nil?) do
        medical = Medical.new
        medical.name = sheet[index, 0]
        medical.relationship = sheet[index, 1]
        medical.date_of_birth = safe_copy_date_value_from_sheet(sheet[index, 2])
        profile.dependents << medical
        index+=1
      end
      profile
    end

    def map_financial_details (profile, excel_book)
      sheet = excel_book.worksheet 5
      profile.pan_no = sheet[3, 1]
      profile
    end

    def safe_copy_string_value_from_sheet (sheet_cell)
      if (sheet_cell.blank?)
        return ""
      end
      sheet_cell.to_s
    end

    def safe_copy_date_value_from_sheet (sheet_cell)
      if (sheet_cell.blank?)
        return nil
      end
      sheet_cell.to_s.to_date
    end

    def safe_copy_integer_value_from_sheet (sheet_cell)
      if (sheet_cell.blank?)
        return nil
      end
      sheet_cell.to_s.to_i
    end

    module_function :import, :new_profile_type, :open_spreadsheet, :map_personal_details, :map_passport_details,
                    :map_experience_details, :map_qualification_details, :map_life_dependent_details,
                    :map_medical_dependent_details, :map_financial_details, :safe_copy_string_value_from_sheet,
                    :safe_copy_date_value_from_sheet, :safe_copy_integer_value_from_sheet
  end

end