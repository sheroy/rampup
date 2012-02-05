require File.dirname(__FILE__) + '/../spec_helper'

describe DataFile do
  it "should upload_spreadsheet the file into public data" do
    uploaded_file = File.open("tmp/tmp_file", "w")
    uploaded_file.close()

    DataFile.save({"datafile"=>"tmp_file"})
    File.exist?("#{Rails.root}/public/system/templates/tmp_file").should be
    File.delete("#{Rails.root}/public/system/templates/tmp_file")
    File.delete("#{Rails.root}/tmp/tmp_file")
  end
end