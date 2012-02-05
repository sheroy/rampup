require 'spreadsheet'
module Exporter
  module ExperienceDistributionExporter
    def export_to_excel(breakdown, path)
      workbook=create_excel
      worksheet = workbook.create_worksheet :name => 'Experience Distribution'
      add_headers(worksheet)
      fill_data(worksheet,breakdown)
      workbook.write path
    end
    def add_headers(worksheet)
      ["Experience","Chennai", "Bangalore", "Pune", "Delhi-Gurgoan","Total"].each_with_index do |header,i|
        worksheet[0,i] = header
      end
      worksheet
    end
    def fill_data(worksheet,breakdown)
      breakdown.each_with_index do |row,i|
        worksheet[i+1,0] = "#{i} to #{i+1} years"
        row.each_with_index do |column,j|
          worksheet[i+1,j+1] = column.to_s
        end
        worksheet[i+1,row.size+1] = row.sum
      end
    end
    def create_excel
      Spreadsheet.client_encoding = 'UTF-8'
      workbook = Spreadsheet::Workbook.new
      workbook
    end
    module_function :export_to_excel, :add_headers, :fill_data, :create_excel
  end
end
