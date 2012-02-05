module Importer
  module PriorExperience
    def import(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0

      sheet.each(2) do |row|                                            
        unless row[1].blank?                                               
          emp_id = ((row[1].class.to_s == "Float") ? row[1].truncate.to_s : row[1].to_s)
          @profile = Profile.find_or_initialize_by_employee_id(emp_id)  
          @profile.save(:validate => false)
          @profile.experiences << java_exp(row) unless row[4].blank?
          @profile.experiences << net_exp(row) unless row[5].blank?
          @profile.experiences << ruby_exp(row) unless row[6].blank?
        end
      end
    end  
    def java_exp(row)
      experience = Experience.new
      experience.technology = "Java"
      experience.duration   = row[4].to_i    
      experience
    end                                                                       
    def net_exp(row)
      experience = Experience.new  
      experience.technology = ".Net"
      experience.duration   = row[5].to_i
      experience
    end            
    def ruby_exp(row)
      experience = Experience.new  
      experience.technology = 'Ruby'           
      experience.duration   = row[6].to_i
      experience
    end
    def open_spreadsheet(path)
      Spreadsheet.client_encoding = 'UTF-8'
      Spreadsheet.open(path)
    end            
    module_function :import, :open_spreadsheet, :java_exp, :net_exp, :ruby_exp
  end  
end
