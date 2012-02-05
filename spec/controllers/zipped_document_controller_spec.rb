require 'spec_helper'

describe ZippedDocumentController do
  it 'should open the zip file and save its contents' do
    zipped_document= {:document_zip=>mock(:path=>:zip_file_path, :original_filename=>"something.zip")}
    controller.should_receive(:open_zip).with(:zip_file_path).and_yield(:document_param_list)
    AttachedDocument.should_receive(:create).with(:document_param_list)

    post :upload, :zipped_document => zipped_document, :id => 42

    flash[:notice].should == 'The zip file was uploaded successfully.'
    response.should redirect_to document_show_upload_path(:document=>42)
  end

  it 'should show a warning when no file is specified' do
    zipped_document= {:document_zip=>nil}
    post :upload, :zipped_document => zipped_document, :id => 42
    flash[:error].should == 'Please specify a file to be uploaded.'
    response.should redirect_to document_show_upload_path(:document=>42)
  end

  it 'should show a warning when the uploaded file is not a zip file' do
    zipped_document= {:document_zip=>mock(:path=>:zip_file_path, :original_filename=>"something.zip")}
    controller.should_receive(:open_zip).with(:zip_file_path).and_raise(Zip::ZipError)

    post :upload, :zipped_document => zipped_document, :id => 42

    flash[:error].should == 'The uploaded file was not a valid zip file.'
    response.should redirect_to document_show_upload_path(:document=>42)
  end

  it "should show a warning if the file does not end in .zip" do
    zipped_document= {:document_zip=>mock(:original_filename=>"something.docx", :path=>:zip_file_path)}

    post :upload, :zipped_document => zipped_document, :id => 42

    flash[:error].should == 'The uploaded file must be in the zip format (*.zip)'
    response.should redirect_to document_show_upload_path(:document=>42)
  end

  describe "sequential_filename" do
    it "should return unique filename with next sequential number" do
      filename = "abc.txt"
      existing_filenames = ["abc.txt", "abc_1.txt", "abc_2.txt"]
      ZippedDocumentController.sequential_filename(filename, existing_filenames).should eql "abc_3.txt"
    end

    it "should maintain filename extension" do
      filename = "abc.doc.txt.zip"
      existing_filenames = ["abc.doc.txt.zip", "abc.doc.txt_1.zip", "abc.doc.txt_2.zip"]
      ZippedDocumentController.sequential_filename(filename, existing_filenames).should eql "abc.doc.txt_3.zip"
    end
  end


end
