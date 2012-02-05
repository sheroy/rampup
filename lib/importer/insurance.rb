module Importer
  module Insurance
    def medical(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(4) do |row| 
        unless row[0].blank?                                       
          emp_id = ((row[0].class.to_s == "Float") ? row[0].truncate.to_s : row[0].to_s)
          profile = Profile.find_or_initialize_by_employee_id(emp_id)
          profile.save(:validate => false)
          profile.dependents<<medical_dependent_1(row) unless row[8].blank?
          profile.dependents<<medical_dependent_2(row) unless row[12].blank?
          profile.dependents<<medical_dependent_3(row) unless row[16].blank?
          profile.dependents<<medical_dependent_4(row) unless row[20].blank?
          profile.dependents<<medical_dependent_5(row) unless row[24].blank?
        end
      end      
    end
    def life(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(4) do |row|
        unless row[0].blank?                                                          
          emp_id = ((row[0].class.to_s == "Float") ? row[0].truncate.to_s : row[0].to_s)   
          profile = Profile.find_or_initialize_by_employee_id(emp_id)
          profile.save(:validate => false)
          profile.lives<<dependent_1(row) unless row[7].blank?
          profile.lives<<dependent_2(row) unless row[10].blank?
        end
      end
    end

    def medical_dependent_5(row)
      dependent = Medical.new
      dependent.name = row[24].to_s unless row[24].blank?
      dependent.relationship = row[25].to_s unless row[25].blank?
      dependent.date_of_birth = row[26] unless row[26].blank?
      return dependent      
    end

    def medical_dependent_4(row)
      dependent = Medical.new
      dependent.name = row[20].to_s unless row[20].blank?
      dependent.relationship = row[21].to_s unless row[21].blank?
      dependent.date_of_birth = row[22] unless row[22].blank?
      return dependent      
    end

    def medical_dependent_3(row)
      dependent = Medical.new
      dependent.name = row[16].to_s unless row[16].blank?
      dependent.relationship = row[17].to_s unless row[17].blank?
      dependent.date_of_birth = row[18] unless row[18].blank?
      return dependent      
    end

    def medical_dependent_2(row)
      dependent = Medical.new
      dependent.name = row[12].to_s unless row[12].blank?
      dependent.relationship = row[13].to_s unless row[13].blank?
      dependent.date_of_birth = row[14] unless row[14].blank?
      return dependent
    end

    def medical_dependent_1(row)
      dependent = Medical.new
      dependent.name = row[8].to_s unless row[8].blank?
      dependent.relationship = row[9].to_s unless row[9].blank?
      dependent.date_of_birth = row[10] unless row[10].blank?
      return dependent
    end
    def dependent_2(row)
      dependent = Life.new
      dependent.name = row[10].to_s unless row[10].blank?
      dependent.relationship = row[11].to_s unless row[11].blank?
      dependent.percentage = row[12].truncate if row[12].class.to_s == "Float"
      return dependent      

    end
    def dependent_1(row)
      dependent = Life.new
      dependent.name = row[7].to_s unless row[7].blank?
      dependent.relationship = row[8].to_s unless row[8].blank?
      dependent.percentage = row[9].truncate if row[9].class.to_s == "Float"
      return dependent      
    end
    def open_spreadsheet(path)
      Spreadsheet.client_encoding = 'UTF-8'
      Spreadsheet.open(path)
    end
    module_function :open_spreadsheet, :life, :dependent_1, :dependent_2, :medical_dependent_1, :medical_dependent_2,
    :medical_dependent_3, :medical_dependent_4, :medical_dependent_5, :medical
  end  
end