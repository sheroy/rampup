require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DocumentController do
  before(:each) do
    params[:query] = "12345"
    profile1 = Profile.new(:employee_id => "12345")
    @profiles = [profile1]
    @mandatory_template_generators = TemplateGenerator.find(:all, :conditions=>{:document_type => true, :selected=> true})
    @optional_template_generators = TemplateGenerator.find(:all, :conditions=>{:document_type => false,:selected=>true})
    @office_names = Letterhead.all.collect { |lh| lh.office_name }.sort do |a,b| a.upcase <=> b.upcase end
    signature1 = Signature.new(:name=>"Prasanna",:signature=>"Prasanna")
    @signatures = [signature1]
    assigns[:profiles] = @profiles
    assigns[:office_names] = @office_names
    assigns[:signatures] = @signatures
  end

  it "should check the presence of signature dropdown menu" do
    render 'app/views/document/show.rhtml'
    response.should have_tag('select#document_signature')
  end
  
  
  it "should display the list of mandatory documents" do
    template1=TemplateGenerator.create!(:name=>'Fred',:file_name=>'file_name', :document_type=>true)
    template3=TemplateGenerator.create!(:name=>'Meredith',:file_name=>'file_name', :document_type=>true)
    assigns[:mandatory_template_generators] = [template1,template3]
    
    render 'app/views/document/show.rhtml'
    response.should have_tag('ul')
      with_tag('li', 'Fred')
      with_tag('li', 'Meredith')
  end
  
  it "should display the list of optional documents" do
    template2=TemplateGenerator.create!(:name=>'Bob',:file_name=>'file_name', :document_type=>false, :selected=>true)
    template4=TemplateGenerator.create!(:name=>'Mansi',:file_name=>'file_name', :document_type=>false, :selected=>false)
    assigns[:optional_template_generators] = [template2,template4]
    
    render 'app/views/document/show.rhtml'
    response.should have_tag('ul')
      with_tag('li', 'Bob')
      with_tag('li', 'Mansi')
  end
end
