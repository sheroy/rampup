require 'spec_helper'
require 'spreadsheet'

describe "ExcelExporter" do

  it "should return the worksheet containing the others field as the last field" do
    workbook=Spreadsheet::Workbook.new
    worksheet = workbook.create_worksheet :name=>'Experience'
    Exporter::ExcelExporter.add_experience_headers(worksheet)
    worksheet.row(0)[8].should == "Other Technology"
    worksheet.row(0)[9].should == nil
  end

  it "should return the worksheet containing user with corresponding Other Technologies" do
    workbook=Spreadsheet::Workbook.new
    worksheet = workbook.create_worksheet :name=>'Experience'
    profile = ModelFactory.create_profile
    ModelFactory.create_experience({:technology => "C++", :last_used => "2009-10-10", :duration=> 2, :profile_id => profile.id})
    ModelFactory.create_experience({:technology => "XML", :last_used => "2009-10-10", :duration=> 2, :profile_id => profile.id})
    Exporter::ExcelExporter.add_experience_data(worksheet, profile, 1)
    worksheet.row(1)[8].should == 'C++ ~ 2 ~ 2009-10-10 |' + $/ + 'XML ~ 2 ~ 2009-10-10'
  end

  it "should not break if there is some null entry present in Experiences data" do
    workbook=Spreadsheet::Workbook.new
    worksheet = workbook.create_worksheet :name=>'Experience'
    profile = ModelFactory.create_profile
    experience=Experience.new(:profile_id => profile.id, :technology => "C++", :last_used => nil, :duration=> nil)
    experience.save(:validate => false)
    Exporter::ExcelExporter.add_experience_data(worksheet, profile, 1)
    worksheet.row(1)[8].should == 'C++ ~  ~ '
  end

end