require 'spreadsheet'

module Importer
  module DegreeImporter
    def import(path)
      excel_sheet = open_spreadsheet(path)
      sheet = excel_sheet.worksheet 0
      sheet.each(2) do |row|
          @degree = Degree.new(:category => row[0], :name => row[1])
          @degree.save(:validate => false)
      end
    end

    def open_spreadsheet(path)
      Spreadsheet.client_encoding = 'UTF-8'
      Spreadsheet.open(path)
    end
    
    module_function :import, :open_spreadsheet
  end
end