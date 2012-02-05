require 'spreadsheet'

module Importer
  module QualificationsImporter
    def import(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 1
      begin
      if validate_headers(sheet)
        sheet.each(2) do |row|         
          @profile = Profile.find_or_initialize_by_employee_id(row[1].truncate.to_s)
          @profile.years_of_experience = ((row[12]*365)/30).truncate
          assign_values(row)
          @profile.save(:validate => false)
        end
      else
        puts "headers not matching"
      end
      rescue Exception => e
        puts e.message
      end
    end

    def validate_headers(sheet)  
        headers = ["S No","PS ID","Common Name (Complete)","First Day","Category","Graduation","Branch","University/ College","Category","Post Graduation (Masters)","Branch","University/ College","Prior to TWI","TWI","Total"]
        headers_row=sheet.row(1)
        i=0
        headers.each do 
           if headers[i]!=headers_row[i]
             return false
           end
           i=i+1
        end
    end
      
    def open_spreadsheet(path)
      Spreadsheet.client_encoding = 'UTF-8'
      Spreadsheet.open(path)
    end

    private
    def assign_values(row)   
      College.find_or_initialize_by_name(row[7]).save
      College.find_or_initialize_by_name(row[11]).save
      Branch.find_or_initialize_by_name(row[6]).save
      Branch.find_or_initialize_by_name(row[10]).save
      qualification1=Qualification.new(:branch => row[6], :college => row[7],:degree=>row[5],:category=>row[4] )
      qualification2=Qualification.new(:branch => row[10], :college => row[11],:degree=>row[9],:category=>row[8] )
      @profile.qualifications<< [qualification1, qualification2]
      @profile
    end
    module_function :import, :open_spreadsheet, :assign_values, :validate_headers
  end
end