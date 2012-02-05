require 'spec_helper'

describe "Form" do
  before :each do
    render :partial => "partials/attached_document/form"
  end

  it "should have the allowed document types listed" do
    types = %w[Passport Education Employment Financial/Tax Other]
    types.each {|type| response.should have_tag "option", "#{type}"}
  end

  it "should have a file upload option" do
    response.should have_tag "input[type=file]#attached_document_document"
  end

  it "should have a file name text field" do
    response.should have_tag "input[type=text]#attached_document_name"
  end

  it "should have button to upload the file" do
    response.should have_tag "input[type=submit]#upload"
  end
end
