require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UploadSpreadsheetController do

  it "should see error message when employee id is empty" do
    flash.stub!(:sweep)
    post :upload_file
    flash.now[:error].should=="You need to enter a unique 5-digit Employee ID."
  end

  it "should see error message when file path is empty" do
    flash.stub!(:sweep)
    post :upload_file, :employee_id => 12345
    flash.now[:error].should=="Please choose a file to upload_spreadsheet"
  end

  it "should see error message when the wrong file is specified" do
    flash.stub!(:sweep)
    post :upload_file, :employee_id => 12345, :upload_spreadsheet => {:datafile => fixture_file_upload('dummy.png', 'image/png')}
    flash.now[:error].should=="Only .xls Excel Files are allowed"
  end

  it "should get a success message when path is correct" do
    flash.stub!(:sweep)
    Location.should_receive(:find_by_name).with("Chennai").and_return("1")
    post :upload_file, :employee_id => 12345, :upload_spreadsheet => {:datafile => fixture_file_upload("../data/Spreadsheet_with_data.xls")}
    profile_id = Profile.find_by_employee_id(12345).id
    response.should redirect_to(show_profile_path(profile_id))
    flash.now[:notice].should=="File has been uploaded successfully<br/>" +
        "Verify all the details and <a href=\"/profile/complete/" + profile_id.to_s + "\">Click here</a> to save as final"
    File.delete("#{Rails.root}/public/system/templates/Spreadsheet_with_data.xls")
  end

end