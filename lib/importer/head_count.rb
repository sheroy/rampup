module Importer
  module HeadCount
    def import(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(1) do |row|
        unless row[1].blank?
          emp_id = ((row[1].class.to_s == "Float") ? row[1].truncate.to_s : row[1].to_s)
          profile = Profile.find_or_initialize_by_employee_id(emp_id)
          if row[2].to_s == "Support"
            profile.type = "Support"
          elsif row[2].to_s == "PS"
            profile.type = "ProfessionalServices"
          elsif row[2].to_s == "ETG PS"
            profile.type = "Etg"
          end
          profile.save(:validate => false)
        end

      end
    end
    def open_spreadsheet(path)
      Spreadsheet.client_encoding = 'UTF-8'
      Spreadsheet.open(path)
    end
    module_function :open_spreadsheet,:import
  end
end