require 'spreadsheet'

module Importer
  module ProfileImporter
    def import(path)
      excel_sheet = open_spreadsheet(path)
      sheet1 = excel_sheet.worksheet 0
      begin
        if validate_headers(sheet1)
          sheet1.each(1) do |row|
            profile = ProfessionalServices.find_or_initialize_by_employee_id(row[0].truncate.to_s)
            profile = assign_values(profile, row)
            profile.save(:validate => false)
          end
        end
      rescue Exception => e
        puts e.message
      end
    end

    def validate_headers(sheet1)
      headers = ["PSID", "SurName", "GivenName", "CommonName", "Title", "FirstDay", "BirthDate", "M/F", "MaritalStatus", "LastDay", "TransferredTo", "Guardian'sName", "1stAddressLine", "2ndAddressLine", "3rdAddressLine", "City", "State", "Pincode", "Location", "TransferredTo", "TransferredDate"]
      headers_row=sheet1.row(0)
      i=0
      headers.each do
        if headers[i]!=headers_row[i]
          return false
        end
        i=i+1
      end
    end

    def open_spreadsheet(path)
      Spreadsheet.client_encoding = "UTF-8//TRANSLIT//IGNORE"
      excel_sheet=Spreadsheet.open(path)
    end

    private
    def assign_values(profile, row)
      profile.employee_id = row[0].truncate.to_s
      profile.name=row[2]
      profile.title = row[4]
      Title.find_or_initialize_by_name(profile.title).save
      profile.surname = row[1]
      profile.common_name = row[3]
      if (row[7].strip) == "M"
        profile.gender = "Male"
      elsif (row[7].strip) == "F"
        profile.gender = "Female"
      end
      if row[8].strip == "S"
        profile.marital_status = "Single"
      elsif row[8].strip == "M"
        profile.marital_status = "Married"
      else
        profile.marital_status = "Others"
      end
      profile.permanent_address_line_1 = row[12]
      profile.temporary_address_line1=row[12]
      profile.permanent_address_line2 = row[13]
      profile.temporary_address_line2=row[13]
      profile.permanent_address_line3 = row[14]
      profile.temporary_address_line3=row[14]
      profile.permanent_city= row[15]
      profile.temporary_city= row[15]
      profile.permanent_state= row[16]
      profile.temporary_state= row[16]
      @a = ""
      row[17].to_s.split(' ').each do |str|
        @a = @a + str
      end
      profile.permanent_pincode= @a
      profile.temporary_pincode=@a
      profile.guardian_name = row[11]
      profile.location_id = Location.find_by_name(row[18]).id
      profile.transfer_to = row[19]
      (profile.transfer_date=row[20].to_date) unless (row[20].nil?)
      (profile.last_day=row[9].to_date) unless (row[9].nil?)
      (row[6].nil?) ? (profile.date_of_birth=Time.zone.today) : (profile.date_of_birth=row[6].to_s.to_date)
      (row[5].nil?) ? (profile.date_of_joining=Time.zone.today) : (profile.date_of_joining=row[5].to_s.to_date)
      profile.transferred_abroad = row[10]
      profile.completed=false
      profile
    end

    module_function :import, :open_spreadsheet, :assign_values, :validate_headers
  end
end