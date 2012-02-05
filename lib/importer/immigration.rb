module Importer
  module Immigration
    def visa(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(3) do |row|
        profile = find_employee(employee_id(row[1]))
        unless profile.nil?
          profile.visas<<american_h1b_visa(row) unless row[11].to_s == "Not Applied"
          profile.visas<<american_b1_visa(row) unless row[17].blank?
          profile.visas<<american_l1a_visa(row) unless row[20].blank?
          profile.visas<<american_l1b_visa(row) unless row[23].blank?
          profile.visas<<uk_work_visa(row) unless row[26].blank?
          profile.visas<<uk_business_visa(row) unless row[32].blank?
          profile.visas<<shengan_visa(row) unless row[35].blank?
          profile.visas<<australian_work_visa(row) unless row[43].blank?
          profile.visas<<australian_business_visa(row) unless row[39].blank?
          profile.visas<<canadian_work_visa(row) unless row[47].blank?
          profile.visas<<canadian_business_visa(row) unless row[51].blank?
          profile.visas<<chinese_visa(row) unless row[55].blank?
          profile.visas<<hong_kong_visa(row) unless row[59].blank?
          profile.visas<<singapore_visa(row) unless row[63].blank?
          profile.visas<<india_visa(row) unless row[67].blank?
        end
      end
    end

    def india_visa(row)
      visa = Visa.new
      visa.category = "India - Employment"
      visa.status = row[67]
      visa.reason = row[68]
      visa.issue_date = row[69].to_date  if row[69].class.to_s == "DateTime"
      visa.expiry_date = row[70].to_date  if row[70].class.to_s == "DateTime"  
      return visa 

    end

    def singapore_visa(row)
      visa = Visa.new
      visa.category = "Singapore - Business Visa"
      visa.status = row[63]
      visa.reason = row[64]
      visa.issue_date = row[65].to_date if row[65].class.to_s == "DateTime"
      visa.expiry_date = row[66].to_date if row[66].class.to_s == "DateTime"    
      return visa 

    end

    def hong_kong_visa(row)
      visa = Visa.new
      visa.category = "HongKong - Work Permit"
      visa.status = row[59]
      visa.reason = row[60]
      visa.issue_date = row[61].to_date if row[61].class.to_s == "DateTime"
      visa.expiry_date = row[62].to_date if row[62].class.to_s == "DateTime"    
      return visa 

    end

    def chinese_visa(row)
      visa = Visa.new
      visa.category = "Chinese - Work Permit"
      visa.status = row[55]
      visa.reason = row[56]
      visa.issue_date = row[57].to_date if row[57].class.to_s == "DateTime"
      visa.expiry_date = row[58].to_date if row[58].class.to_s == "DateTime"    
      return visa 

    end

    def canadian_work_visa(row)
      visa = Visa.new
      visa.category = "Canadian - Work Permit"
      visa.status = row[47]
      visa.visa_type = row[48]
      visa.issue_date = row[49].to_date if row[49].class.to_s == "DateTime"
      visa.expiry_date = row[50].to_date if row[50].class.to_s == "DateTime"    
      return visa 

    end

    def canadian_business_visa(row)
      visa = Visa.new
      visa.category = "Canadian - Business"
      visa.status = row[51]
      visa.visa_type = row[52]
      visa.issue_date = row[53].to_date  if row[53].class.to_s == "DateTime"
      visa.expiry_date = row[54].to_date  if row[54].class.to_s == "DateTime"   
      return visa 

    end

    def australian_work_visa(row)
      visa = Visa.new
      visa.category = "Australian - Work Permit"
      visa.status = row[43]
      visa.visa_type = row[44]
      visa.issue_date = row[45].to_date if row[45].class.to_s == "DateTime"
      visa.expiry_date = row[46].to_date if row[46].class.to_s == "DateTime"    
      return visa 
    end

    def australian_business_visa(row)
      visa = Visa.new
      visa.category = "Australian - Business"
      visa.status = row[39]
      visa.visa_type = row[40]
      visa.issue_date = row[41].to_date if row[41].class.to_s == "DateTime"
      visa.expiry_date = row[42].to_date if row[42].class.to_s == "DateTime"
      return visa
    end

    def shengan_visa(row)
      visa = Visa.new
      visa.category = "Schengen"
      visa.status = row[35]
      visa.visa_type = row[36]
      visa.issue_date = row[37].to_date if row[37].class.to_s == "DateTime"
      visa.expiry_date = row[38].to_date if row[38].class.to_s == "DateTime"
      return visa
    end

    def uk_work_visa(row)
      visa = Visa.new
      visa.category = "UK - Work Permit"
      visa.status = row[26]
      visa.visa_type = row[27]
      visa.issue_date = row[28].to_date if row[28].class.to_s == "DateTime"
      visa.expiry_date = row[29].to_date if row[29].class.to_s == "DateTime"
      return visa
    end

    def uk_business_visa(row)
      visa = Visa.new
      visa.category = "UK - Business"
      visa.status = row[32]
      visa.issue_date = row[33].to_date  if row[33].class.to_s == "DateTime"
      visa.expiry_date = row[34].to_date if row[34].class.to_s == "DateTime"
      return visa
    end

    def american_l1b_visa(row)
      visa = Visa.new
      visa.category = "US L1B"
      visa.status = row[23]
      visa.issue_date = row[24].to_date if row[24].class.to_s == "DateTime"
      visa.expiry_date = row[25].to_date if row[25].class.to_s == "DateTime"
      return visa
    end
    def american_l1a_visa(row)
      visa = Visa.new
      visa.category = "US L1A"
      visa.status = row[20]
      visa.issue_date = row[21].to_date if row[21].class.to_s == "DateTime"
      visa.expiry_date = row[22].to_date if row[22].class.to_s == "DateTime"
      return visa
    end
    def american_b1_visa(row)
      visa = Visa.new
      visa.category = "US B1"
      visa.status = row[17]
      visa.issue_date = row[18].to_date  if row[18].class.to_s == "DateTime"
      visa.expiry_date = row[19].to_date if row[19].class.to_s == "DateTime"
      return visa
    end
    def american_h1b_visa(row)
      visa = Visa.new
      visa.category = "US H1B"
      visa.petition_status = row[11]
      visa.timeline = row[12]
      visa.appointment_date = row[13]
      visa.status = row[14]
      visa.issue_date = row[15].to_date   if row[15].class.to_s == "DateTime"
      visa.expiry_date = row[16].to_date  if row[16].class.to_s == "DateTime"
      return visa      
    end
    def passport(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(3) do |row|    
        profile = find_employee(employee_id(row[1]))
        unless profile.nil?
          if profile.passport.nil?
            profile.passport = Passport.new
          end
          passport = profile.passport
          unless row[7].nil?
            passport.number = row[7].to_s
          end
          unless row[6].nil?   
            passport.date_of_expiry = row[6].to_date if row[6].class.to_s == "DateTime"
          end                                                

          unless row[10].nil?              
            if row[10].class.to_s == "String"   
              nationality = Country.find_or_initialize_by_name(row[10])
              nationality.save
              passport.nationality = nationality.name  
            end
          end                                                

          passport.save(:validate => false)
          profile.save(:validate => false)
        end            
      end
    end

    def find_employee(employee_id)
      unless employee_id.nil?
        return Profile.find_or_initialize_by_employee_id(employee_id)
      end
      return nil
    end

    def employee_id(cell)
      if cell.class.to_s != "NilClass"
        if cell.class.to_s == "Float"
          return cell.truncate.to_s
        elsif cell.class.to_s == "String"
          return cell.to_s
        end
      end
      return nil
    end

    def open_spreadsheet(path)
      Spreadsheet.client_encoding = 'UTF-8'
      Spreadsheet.open(path)
    end
    module_function :open_spreadsheet,:employee_id, :find_employee, :passport, :visa,:american_h1b_visa,
    :american_b1_visa, :american_l1a_visa, :uk_work_visa, :uk_business_visa, :shengan_visa, :australian_business_visa,
    :australian_work_visa, :canadian_business_visa, :canadian_work_visa, :chinese_visa, :hong_kong_visa,
    :singapore_visa, :india_visa, :american_l1b_visa
  end
end