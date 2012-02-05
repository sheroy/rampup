require "spec_helper"

describe AttachedDocumentController do
  describe "upload" do
    before :each do
      document_type = "Passport"
      name = "Passport first page"
      @params = {:attached_document => {"document_type" => document_type, "name" => name, "document" => fixture_file_upload("../data/scanned_document.jpg")}}

      user = mock(User, :username => :jesus)
      controller.stub!(:current_user).and_return(user)

      profile = mock(:id => 1, :employee_id => "12345")
      Profile.should_receive(:find_by_email_id).with(:jesus).and_return(profile)

      controller.stub!(:redirect_to_document_path)
    end

    it "should create an attached document with the correct profile" do
      controller.should_receive(:open_attached_document).and_yield(:document_param_list)
      AttachedDocument.should_receive(:create).with(:document_param_list)

      controller.should_receive(:redirect_to_document_path)

      post :upload, @params

      flash[:notice].should == 'File successfully uploaded.'
    end

    it "should display multiple errors when a mistake is made while uploading" do
      params_without_document_type = {:attached_document => {"profile_id" => 1, "document_type" => "", "name" => name, "document" => nil}}
      post :upload, params_without_document_type
      flash[:error].should include_text "Following errors prohibited the file from being uploaded<br>"
      flash[:error].should include_text "Please select a document type"
      flash[:error].should include_text "Please select a document to upload"
    end

    it "should display a warning when a file of the wrong type is uploaded" do
      params_with_bad_document = {:attached_document => {"profile_id" => 1, "document_type" => "Other", "name" => name, "document" => fixture_file_upload("../data/sample_upload_profile.xls")}}
      post :upload, params_with_bad_document
      flash[:error].should include_text "Following errors prohibited the file from being uploaded<br>"
      flash[:error].should include_text "Please select a file that is jpg, jpeg, gif, tiff, png, pdf or bmp"
    end


    it "should display error if document_type not supplied" do
      params_without_document_type = {:attached_document => {:profile_id => 1, :document_type => "", :name => name, :document => fixture_file_upload("../data/scanned_document.jpg")}}
      post :upload, params_without_document_type
      flash[:error].should include "Please select a document type"
    end

    it 'should show a warning when no file is specified' do
      params_without_document = {:attached_document => {:document_type => "Passport", :name => "Passport first page", :document => nil}}

      controller.should_receive(:redirect_to_document_path)

      post :upload, params_without_document

      flash[:error].should include_text 'Please select a document to upload'
    end

    it 'should create a default name when no name is specified' do
      file = fixture_file_upload("../data/scanned_document.jpg")
      params_without_name = {:attached_document => {:document_type => "Passport", :name => "", :document => file}}

      controller.should_receive(:open_attached_document).and_yield(:document_param_list)

      AttachedDocument.should_receive(:create).with(:document_param_list).and_return(mock(AttachedDocument, :valid? => true))
      controller.should_receive(:redirect_to_document_path)

      post :upload, params_without_name

      flash[:notice].should == 'File successfully uploaded.'
    end
  end

  describe "download" do
    before :each do
      @selected_documents = [1]
      @params_with_selected_documents = {:selected => @selected_documents, :id => "123"}
    end

    it "should redirect /attached_documents/process_documents" do
      controller.stub!(:documents_selected?).and_return(true)
      controller.should_receive(:download_documents)
      params_with_commit_tag = {:commit => "Download"}
      get :process_documents, params_with_commit_tag
    end

    it "should find attached documents based on id" do
      TemplateEngine.stub!(:bundle)
      controller.stub!(:send_zip)
      AttachedDocument.should_receive(:find).with(@selected_documents)
      zip_directory = "#{Rails.root}/tmp/"
      zip_filename = "Employee_Documents_123"
      controller.should_receive(:send_zip).with(File.join(zip_directory, zip_filename + ".zip"))
      get :download_documents, @params_with_selected_documents
    end

    it "should create array of filepaths" do
      attached_document = mock(AttachedDocument)
      attached_document.stub_chain(:document, :path).and_return("folder/foo.doc")
      AttachedDocument.should_receive(:find).with(@selected_documents).and_return([attached_document])
      controller.stub!(:params).and_return(@params_with_selected_documents)
      controller.retrieve_file_paths.should eql ["folder/foo.doc"]
    end

    it "should call bundle and provide filepaths" do
      filepaths = ["folder/foo.doc"]
      controller.stub!(:retrieve_file_paths).and_return(filepaths)
      controller.stub!(:send_zip)
      TemplateEngine.should_receive(:bundle).with(filepaths, anything(), anything(), anything(), anything())
      get :download_documents, @params_with_selected_documents
    end

    it "should send file to be downloaded" do
      controller.stub!(:retrieve_file_paths)
      TemplateEngine.stub!(:bundle)
      controller.should_receive(:send_zip).with("#{Rails.root}/tmp/Employee_Documents_123.zip")
      get :download_documents, @params_with_selected_documents
    end
  end

  describe "delete" do
    before :each do
      @selected_documents = [1]
      @params_with_selected_documents = {:selected => @selected_documents}
    end

    it "should redirect /attached_documents/delete" do
      controller.stub!(:documents_selected?).and_return(true)
      controller.should_receive(:delete)
      params_with_commit_tag = {:commit => "Delete"}
      get :process_documents, params_with_commit_tag
    end

    it "should delete the documents based on id" do
      attached_doc= mock(AttachedDocument, :profile_id => 123)
      AttachedDocument.should_receive(:find).with(1).and_return(attached_doc)
      attached_doc.should_receive("document=").with(nil)
      attached_doc.should_receive(:save)
      attached_doc.should_receive(:delete).and_return(true)
      get :delete, @params_with_selected_documents

      flash[:notice].should == "Deleted successfully."
    end

    it "should show an error message if delete fails" do
      attached_doc= mock(AttachedDocument, :profile_id => 123)
      AttachedDocument.should_receive(:find).with(1).and_return(attached_doc)
      attached_doc.should_receive("document=").with(nil)
      attached_doc.should_receive(:save)
      attached_doc.should_receive(:delete).and_return(false)
      attached_doc.should_receive(:name).and_return("filename")
      get :delete, @params_with_selected_documents
      flash[:error].should == "Errors while deleting filename<br>"
    end
  end

  describe "redirect_to_document_path" do
    it "should redirect to document_show_upload_path if current user is an admin" do
      user = mock(User, :username => :arnie, :role => "admin")
      controller.stub!(:current_user).and_return(user)
      User.stub!(:isAdmin).and_return(true)
      params_with_error = {:commit => "Download", :selected => nil}
      get :process_documents, params_with_error
      response.should redirect_to(document_show_upload_path)
    end

    it "should redirect to employee_documents_path if current user is an employee" do
      user = mock(User, :username => :arnie, :role => "employee")
      controller.stub!(:current_user).and_return(user)
      User.stub!(:isAdmin).and_return(false)
      params_with_error = {:commit => "Download", :selected => nil}
      get :process_documents, params_with_error
      response.should redirect_to employee_documents_path
    end
  end
end
