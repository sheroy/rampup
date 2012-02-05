module Importer
  module Financial
    def import(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(1) do |row|
        unless row[2].blank?
          emp_id = (row[2].class.to_s == "Float") ? row[2].truncate.to_s : emp_id = row[2].to_s
          profile = Profile.find_or_initialize_by_employee_id(emp_id)
          unless row[4].blank?
            row[4].class.to_s == "Float" ? account_no = row[4].truncate.to_s : account_no = row[4].to_s
            profile.account_no = account_no 
          end
          unless row[5].blank?
            pan_no = (row[5].class.to_s == "Float" ? row[5].truncate.to_s : row[5].to_s) 
            profile.pan_no = pan_no
          end
          unless row[1].blank?
            epf_no = ((row[1].class.to_s == "Float") ? row[1].truncate.to_s : row[1].to_s)
            profile.epf_no = epf_no
          end          
          profile.save(:validate => false)
        end
      end
    end
  def open_spreadsheet(path)
    Spreadsheet.client_encoding = 'UTF-8'
    Spreadsheet.open(path)
  end
  module_function :open_spreadsheet, :import
end
end