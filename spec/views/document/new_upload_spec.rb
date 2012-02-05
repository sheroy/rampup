require "spec_helper"

describe "NewUploadView" do
  before(:each) do
    @profile = mock("profile",
      :id=>1
    )

    assigns[:profile] = @profile
   end

  it "should display the form for uploading a document zip file" do
    attached_documents = [ModelFactory.create_attached_document]

    @profile.should_receive(:common_name).and_return("Some Guy")
    @profile.should_receive(:attached_documents).and_return(attached_documents)

    template.should_receive(:render).with(:partial => 'partials/document/new_upload')

    render :template => 'document/show_upload'
  end

end
