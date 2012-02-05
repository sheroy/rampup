require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def createTestTemplate mandatory, file_description, file_extension
  TemplateGenerator.create!(:selected => true, :name => file_description, :file_name => "test." + file_extension, :document_type => mandatory)
end

def validateZipFile zip_name, expected_file_ext, include_letterhead=false
  File.exists?("#{Rails.root}/public/system/templates/" + zip_name + "_#{@profile.employee_id}.zip").should==true
  zipfile=Zip::ZipFile.open("#{Rails.root}/public/system/templates/" + zip_name + "_#{@profile.employee_id}.zip")
  filename = include_letterhead ? 'letterhead_test.pdf' : 'test' + expected_file_ext
  zipfile.find_entry(zip_name + "_#{@profile.employee_id}/#{filename}").nil?.should==false
  File.delete("#{Rails.root}/public/system/templates/" + zip_name + "_#{@profile.employee_id}.zip")
  File.delete("#{Rails.root}/tmp/test"+expected_file_ext)
end

describe DocumentController do
  before(:each) do
    @profile = ModelFactory.create_profile()
  end
  it "should search for a profile and show all the optional and mandatory documents" do
    mandatory_files = createTestTemplate(true, "mandatory_file", "htm")
    optional_files = createTestTemplate(false, "optional_file", "htm")
    get  :show, :query => 'Mohan'
    response.should be
    assigns[:profiles].should == [@profile]
    assigns[:mandatory_template_generators].should == [mandatory_files]
    assigns[:optional_template_generators].should == [optional_files]
  end

  it "should generate all the mandatory documents" do
    mandatory_files = createTestTemplate(true, "mandatory_file", "xml")
    get :generate_documents,:document=>@profile.id,:commit=>'Generate Mandatory Documents'
    validateZipFile("New Hire Docs",".doc")
  end

  it "should generate all the optional documents" do
    optional_files = createTestTemplate(false, "optional_file", "htm")
    get :generate_documents,:document=>@profile.id, :optional => [optional_files.id]
    validateZipFile("Optional Docs",".pdf")
  end

  it "should show employee search form for document upload" do
      get :employee_search
      response.should be_success
  end

  it "should redirect to upload documents page with correct profile" do
      get :show_upload,:document=>@profile.id
      assigns[:profile].should == @profile
  end

end



