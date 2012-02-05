require 'spec_helper'

describe "List" do
  it "should show the documents only if not a nil list" do
    assert_no_render_for nil
  end

  it "should show the documents only if not a empty list" do
    assert_no_render_for []
  end
  
  def assert_no_render_for list
    render :partial => "partials/attached_document/list", :locals => {:attached_documents => list}
    response.should_not have_tag "table#list_of_attached_documents"
  end

  it "should display files with matching check boxes" do
    documents = [ModelFactory.create_attached_document]
    render :partial => "partials/attached_document/list", :locals => {:attached_documents => documents, :profile_id => "123"}
    response.should have_tag "input[type='checkbox'][value='#{documents.first.id}']"
  end

end